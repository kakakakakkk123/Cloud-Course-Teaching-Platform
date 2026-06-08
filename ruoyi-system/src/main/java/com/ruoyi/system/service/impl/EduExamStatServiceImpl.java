package com.ruoyi.system.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.alibaba.fastjson2.JSON;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.domain.exam.EduExamAnswer;
import com.ruoyi.system.domain.exam.EduExamQuestion;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduExamReviewAnswerSubmit;
import com.ruoyi.system.domain.exam.EduExamReviewDetailVO;
import com.ruoyi.system.domain.exam.EduExamReviewQuestionVO;
import com.ruoyi.system.domain.exam.EduExamReviewSubmitBody;
import com.ruoyi.system.domain.exam.EduExamStatOverview;
import com.ruoyi.system.domain.exam.EduQuestionOption;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.mapper.EduExamRuntimeMapper;
import com.ruoyi.system.mapper.EduExamStatMapper;
import com.ruoyi.system.mapper.StudentLearningMapper;
import com.ruoyi.system.service.IEduExamStatService;

/**
 * 考试统计服务实现
 *
 * @author ruoyi
 */
@Service
public class EduExamStatServiceImpl implements IEduExamStatService
{
    private static final BigDecimal ZERO_SCORE = BigDecimal.ZERO.setScale(2);

    @Autowired
    private EduExamStatMapper examStatMapper;

    @Autowired
    private EduExamRuntimeMapper examRuntimeMapper;

    @Autowired
    private EduExamMapper examMapper;

    @Autowired
    private StudentLearningMapper studentLearningMapper;

    @Override
    public EduExamStatOverview selectExamStatOverview(Long examId)
    {
        return examStatMapper.selectExamStatOverview(examId);
    }

    @Override
    public List<EduExamRecord> selectExamStatRecordList(EduExamRecord record)
    {
        return examStatMapper.selectExamStatRecordList(record);
    }

    @Override
    public EduExamReviewDetailVO selectExamReviewDetail(Long recordId)
    {
        EduExamRecord record = getExamRecord(recordId);
        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(record.getExamId());
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);
        Map<Long, EduExamAnswer> answerMap = new HashMap<>();
        for (EduExamAnswer answer : answerList)
        {
            answerMap.put(answer.getQuestionId(), answer);
        }

        List<EduExamReviewQuestionVO> reviewQuestionList = new ArrayList<>();
        for (EduExamQuestion question : questionList)
        {
            EduExamAnswer answer = answerMap.get(question.getQuestionId());
            EduExamReviewQuestionVO vo = new EduExamReviewQuestionVO();
            vo.setAnswerId(answer == null ? null : answer.getAnswerId());
            vo.setQuestionId(question.getQuestionId());
            vo.setQuestionType(question.getQuestionType());
            vo.setQuestionOrder(question.getQuestionOrder());
            vo.setQuestionTitle(question.getQuestionTitle());
            vo.setAttachmentUrl(question.getAttachmentUrl());
            vo.setStandardAnswer(question.getStandardAnswer());
            vo.setStudentAnswer(answer == null ? "" : answer.getStudentAnswer());
            vo.setAnalysisSnapshot(question.getAnalysisSnapshot());
            vo.setIsCorrect(answer == null ? null : answer.getIsCorrect());
            vo.setQuestionScore(defaultScore(question.getQuestionScore()));
            if (answer == null)
            {
                vo.setActualScore(requiresManualReview(question) ? null : ZERO_SCORE);
            }
            else if (requiresManualReview(question) && answer.getCheckedTime() == null)
            {
                vo.setActualScore(null);
            }
            else
            {
                vo.setActualScore(defaultScore(answer.getActualScore()));
            }
            vo.setTeacherComment(answer == null ? "" : answer.getTeacherComment());
            vo.setAutoMarking(question.getAutoMarking());
            vo.setOptionList(parseOptionSnapshot(question.getOptionSnapshot()));
            reviewQuestionList.add(vo);
        }

        EduExamReviewDetailVO detail = new EduExamReviewDetailVO();
        detail.setRecordId(record.getRecordId());
        detail.setExamId(record.getExamId());
        detail.setRecordStatus(record.getRecordStatus());
        detail.setCheckedFlag(record.getCheckedFlag());
        detail.setObjectiveScore(defaultScore(record.getObjectiveScore()));
        detail.setSubjectiveScore(defaultScore(record.getSubjectiveScore()));
        detail.setTotalScore(defaultScore(record.getTotalScore()));
        detail.setQuestionList(reviewQuestionList);
        return detail;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitExamReview(Long recordId, EduExamReviewSubmitBody body, Long teacherId, String teacherName)
    {
        EduExamRecord record = getExamRecord(recordId);
        if (!"2".equals(record.getRecordStatus()) && !"3".equals(record.getRecordStatus()))
        {
            throw new ServiceException("当前作答记录还未进入可批改状态");
        }

        EduExam exam = examMapper.selectEduExamById(record.getExamId());
        if (exam == null)
        {
            throw new ServiceException("关联考试不存在");
        }

        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(record.getExamId());
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);
        Map<Long, EduExamQuestion> questionById = new HashMap<>();
        for (EduExamQuestion question : questionList)
        {
            questionById.put(question.getQuestionId(), question);
        }

        Map<Long, EduExamReviewAnswerSubmit> submitMap = new HashMap<>();
        if (body != null && body.getAnswers() != null)
        {
            for (EduExamReviewAnswerSubmit item : body.getAnswers())
            {
                if (item != null && item.getAnswerId() != null)
                {
                    submitMap.put(item.getAnswerId(), item);
                }
            }
        }

        Date now = new Date();
        for (EduExamAnswer answer : answerList)
        {
            EduExamQuestion question = questionById.get(answer.getQuestionId());
            if (!requiresManualReview(question))
            {
                continue;
            }
            EduExamReviewAnswerSubmit submit = submitMap.get(answer.getAnswerId());
            if (submit == null)
            {
                continue;
            }
            validateReviewScore(submit.getActualScore(), defaultScore(answer.getQuestionScore()));

            EduExamAnswer update = new EduExamAnswer();
            update.setAnswerId(answer.getAnswerId());
            update.setActualScore(defaultScore(submit.getActualScore()));
            update.setTeacherComment(StringUtils.defaultString(submit.getTeacherComment()));
            update.setCheckedBy(teacherId);
            update.setCheckedTime(now);
            examRuntimeMapper.updateStudentAnswer(update);

            answer.setActualScore(defaultScore(submit.getActualScore()));
            answer.setTeacherComment(StringUtils.defaultString(submit.getTeacherComment()));
            answer.setCheckedBy(teacherId);
            answer.setCheckedTime(now);
        }

        boolean finalize = body != null && Boolean.TRUE.equals(body.getFinalize());
        boolean allManualChecked = true;
        BigDecimal objectiveScore = ZERO_SCORE;
        BigDecimal subjectiveScore = ZERO_SCORE;
        for (EduExamAnswer answer : answerList)
        {
            EduExamQuestion question = questionById.get(answer.getQuestionId());
            BigDecimal actualScore = defaultScore(answer.getActualScore());
            if (requiresManualReview(question))
            {
                subjectiveScore = subjectiveScore.add(actualScore);
                if (answer.getCheckedTime() == null)
                {
                    allManualChecked = false;
                }
            }
            else
            {
                objectiveScore = objectiveScore.add(actualScore);
            }
        }

        if (finalize && !allManualChecked)
        {
            throw new ServiceException("仍有主观题尚未评分，请完成所有主观题后再提交批改");
        }

        BigDecimal totalScore = objectiveScore.add(subjectiveScore);
        EduExamRecord finishRecord = new EduExamRecord();
        finishRecord.setRecordId(recordId);
        finishRecord.setRecordStatus(finalize && allManualChecked ? "3" : "2");
        finishRecord.setObjectiveScore(objectiveScore);
        finishRecord.setSubjectiveScore(subjectiveScore);
        finishRecord.setTotalScore(totalScore);
        finishRecord.setResultStatus(comparePassFlag(totalScore, exam.getPassScore()));
        finishRecord.setCheckedFlag(allManualChecked ? "1" : "0");
        finishRecord.setUpdateBy(teacherName);
        if (studentLearningMapper.finishExamReview(finishRecord) <= 0) {
            throw new ServiceException("考试记录不存在或状态异常");
        }
    }

    private EduExamRecord getExamRecord(Long recordId)
    {
        EduExamRecord record = examStatMapper.selectExamStatRecordById(recordId);
        if (record == null)
        {
            throw new ServiceException("考试记录不存在");
        }
        return record;
    }

    private boolean requiresManualReview(EduExamQuestion question)
    {
        if (question == null)
        {
            return false;
        }
        return !"1".equals(StringUtils.defaultString(question.getAutoMarking(), "1"));
    }

    private void validateReviewScore(BigDecimal actualScore, BigDecimal maxScore)
    {
        if (actualScore == null)
        {
            throw new ServiceException("请填写主观题得分");
        }
        if (actualScore.compareTo(BigDecimal.ZERO) < 0)
        {
            throw new ServiceException("主观题得分不能小于 0");
        }
        if (actualScore.compareTo(defaultScore(maxScore)) > 0)
        {
            throw new ServiceException("主观题得分不能超过题目分值");
        }
    }

    private List<EduQuestionOption> parseOptionSnapshot(String optionSnapshot)
    {
        if (StringUtils.isBlank(optionSnapshot))
        {
            return Collections.emptyList();
        }
        return JSON.parseArray(optionSnapshot, EduQuestionOption.class);
    }

    private BigDecimal defaultScore(BigDecimal score)
    {
        return score == null ? ZERO_SCORE : score;
    }

    private String comparePassFlag(BigDecimal score, BigDecimal passScore)
    {
        return defaultScore(score).compareTo(defaultScore(passScore)) >= 0 ? "1" : "0";
    }
}
