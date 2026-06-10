package com.ruoyi.system.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.StudentProfile;
import com.ruoyi.system.domain.course.EduCourseContent;
import com.ruoyi.system.domain.course.EduCourseEnroll;
import com.ruoyi.system.domain.exam.EduExam;
import com.ruoyi.system.domain.exam.EduExamAnswer;
import com.ruoyi.system.domain.exam.EduExamQuestion;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduPaper;
import com.ruoyi.system.domain.exam.EduPaperQuestion;
import com.ruoyi.system.domain.exam.EduQuestion;
import com.ruoyi.system.domain.exam.EduQuestionOption;
import com.ruoyi.system.domain.learning.CourseDiscussion;
import com.ruoyi.system.domain.learning.StudentExamAnswerBody;
import com.ruoyi.system.domain.learning.StudentExamAnswerItem;
import com.ruoyi.system.domain.learning.StudentExamPaperVO;
import com.ruoyi.system.domain.learning.StudentExamQuestionVO;
import com.ruoyi.system.domain.learning.StudentExamResultVO;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentExamWrongQuestionVO;
import com.ruoyi.system.domain.learning.StudentLearningOverview;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduCourseEnrollMapper;
import com.ruoyi.system.mapper.EduCourseMapper;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.mapper.EduExamRuntimeMapper;
import com.ruoyi.system.mapper.EduPaperMapper;
import com.ruoyi.system.mapper.EduPaperQuestionMapper;
import com.ruoyi.system.mapper.EduQuestionMapper;
import com.ruoyi.system.mapper.StudentAccountMapper;
import com.ruoyi.system.mapper.StudentLearningMapper;
import com.ruoyi.system.service.IEduStudentLearningService;

/**
 * 学生学习服务实现
 */
@Service
public class EduStudentLearningServiceImpl implements IEduStudentLearningService
{
    private static final BigDecimal ZERO_SCORE = BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);

    @Autowired
    private StudentLearningMapper studentLearningMapper;

    @Autowired
    private EduCourseContentMapper courseContentMapper;

    @Autowired
    private EduCourseEnrollMapper courseEnrollMapper;

    @Autowired
    private EduCourseMapper courseMapper;

    @Autowired
    private EduExamMapper examMapper;

    @Autowired
    private EduPaperMapper paperMapper;

    @Autowired
    private EduQuestionMapper questionMapper;

    @Autowired
    private EduPaperQuestionMapper paperQuestionMapper;

    @Autowired
    private EduExamRuntimeMapper examRuntimeMapper;

    @Autowired
    private StudentAccountMapper studentAccountMapper;

    @Override
    public StudentLearningOverview selectLearningOverview(Long studentId)
    {
        StudentLearningOverview overview = studentLearningMapper.selectLearningOverview(studentId);
        if (overview == null)
        {
            overview = new StudentLearningOverview();
        }
        overview.setPendingExamCount(studentLearningMapper.selectPendingExamCount(studentId));
        return overview;
    }

    @Override
    public List<StudentExamVO> selectStudentExamList(Long studentId, String status)
    {
        return studentLearningMapper.selectStudentExamList(studentId, status);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markContentLearned(Long contentId, Long studentId)
    {
        EduCourseContent content = courseContentMapper.selectPublishedContentById(contentId);
        if (StringUtils.isNull(content))
        {
            throw new ServiceException("课程内容不存在或尚未发布");
        }
        EduCourseEnroll enroll = courseEnrollMapper.selectEduCourseEnroll(content.getCourseId(), studentId);
        if (StringUtils.isNull(enroll))
        {
            throw new ServiceException("请先注册该课程再开始学习");
        }

        int totalCount = courseContentMapper.countPublishedContentByCourseId(content.getCourseId());
        if (totalCount <= 0)
        {
            return;
        }
        int learnedPosition = courseContentMapper.countLearnedContentPosition(content);
        BigDecimal progress = BigDecimal.valueOf(learnedPosition)
                .multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(totalCount), 2, RoundingMode.HALF_UP);
        courseEnrollMapper.updateLearningProgress(content.getCourseId(), studentId, progress);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public EduExamRecord startExam(Long examId, Long studentId)
    {
        EduExam exam = getPublishedExam(examId);
        validateExamTime(exam);
        ensureStudentEnrolledForExam(exam, studentId);
        ensureExamQuestionSnapshot(exam);

        EduExamRecord runningRecord = studentLearningMapper.selectRunningExamRecord(examId, studentId);
        if (runningRecord != null)
        {
            bootstrapExamAnswersIfNeeded(runningRecord);
            return runningRecord;
        }

        int attemptCount = defaultInt(studentLearningMapper.selectExamAttemptCount(examId, studentId));
        int maxAttemptCount = exam.getMaxAttemptCount() == null || exam.getMaxAttemptCount() <= 0 ? 1 : exam.getMaxAttemptCount();
        if (attemptCount >= maxAttemptCount)
        {
            throw new ServiceException("已达到本场考试最大参加次数");
        }

        EduExamRecord record = new EduExamRecord();
        record.setExamId(exam.getExamId());
        record.setPaperId(exam.getPaperId());
        record.setCourseId(exam.getCourseId());
        record.setStudentId(studentId);
        record.setAttemptNo(attemptCount + 1);
        studentLearningMapper.insertExamRecord(record);
        bootstrapExamAnswersIfNeeded(record);
        return studentLearningMapper.selectExamRecordById(record.getRecordId(), studentId);
    }

    @Override
    public StudentExamPaperVO selectStudentExamPaper(Long recordId, Long studentId)
    {
        EduExamRecord record = getRunningExamRecord(recordId, studentId);
        EduExam exam = getPublishedExam(record.getExamId());
        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(exam.getExamId());
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);

        StudentExamPaperVO vo = new StudentExamPaperVO();
        vo.setRecordId(record.getRecordId());
        vo.setExamId(exam.getExamId());
        vo.setPaperId(exam.getPaperId());
        vo.setCourseId(exam.getCourseId());
        vo.setExamName(exam.getExamName());
        vo.setCourseName(exam.getCourseName());
        vo.setPaperName(exam.getPaperName());
        vo.setExamNotice(exam.getExamNotice());
        vo.setDurationMinutes(exam.getDurationMinutes());
        vo.setDurationSeconds(defaultInt(exam.getDurationMinutes()) * 60);
        vo.setRemainingSeconds(calculateRemainingSeconds(record, exam));
        vo.setStartTime(exam.getStartTime());
        vo.setEndTime(exam.getEndTime());
        vo.setRecordStartTime(record.getStartTime());
        vo.setRecordStatus(record.getRecordStatus());
        vo.setShowAnswerAfterSubmit(exam.getShowAnswerAfterSubmit());
        vo.setShowScoreAfterSubmit(exam.getShowScoreAfterSubmit());
        vo.setQuestionList(buildQuestionVOList(questionList, answerList, false, false));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveExamAnswers(Long recordId, Long studentId, StudentExamAnswerBody body)
    {
        EduExamRecord record = getRunningExamRecord(recordId, studentId);
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);
        if (StringUtils.isEmpty(answerList))
        {
            throw new ServiceException("当前考试未生成答题明细");
        }

        Map<Long, StudentExamAnswerItem> answerMap = new HashMap<>();
        if (body != null && StringUtils.isNotEmpty(body.getAnswers()))
        {
            for (StudentExamAnswerItem item : body.getAnswers())
            {
                if (item.getQuestionId() != null)
                {
                    answerMap.put(item.getQuestionId(), item);
                }
            }
        }

        for (EduExamAnswer answer : answerList)
        {
            StudentExamAnswerItem item = answerMap.get(answer.getQuestionId());
            if (item == null)
            {
                continue;
            }
            answer.setStudentAnswer(StringUtils.trimToEmpty(item.getStudentAnswer()));
            examRuntimeMapper.updateStudentAnswer(answer);
        }
    }

    @Override
    public Map<String, Object> selectExamContent(Long recordId, Long studentId)
    {
        StudentExamPaperVO paper = selectStudentExamPaper(recordId, studentId);
        Map<String, Object> content = new LinkedHashMap<>();
        content.put("exam", paper);
        content.put("questions", paper.getQuestionList());
        return content;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitExam(Long recordId, Long studentId)
    {
        EduExamRecord record = getRunningExamRecord(recordId, studentId);
        EduExam exam = getPublishedExam(record.getExamId());
        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(exam.getExamId());
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);
        if (StringUtils.isEmpty(questionList) || StringUtils.isEmpty(answerList))
        {
            throw new ServiceException("当前考试缺少题目明细，无法提交");
        }

        Map<Long, EduExamQuestion> questionMap = new HashMap<>();
        for (EduExamQuestion question : questionList)
        {
            questionMap.put(question.getQuestionId(), question);
        }

        BigDecimal objectiveScore = ZERO_SCORE;
        boolean hasManualQuestion = false;
        for (EduExamAnswer answer : answerList)
        {
            EduExamQuestion question = questionMap.get(answer.getQuestionId());
            if (question == null)
            {
                continue;
            }
            if (!"1".equals(question.getAutoMarking()) || "5".equals(question.getQuestionType()))
            {
                hasManualQuestion = true;
                continue;
            }

            boolean correct = judgeAnswer(question, answer.getStudentAnswer());
            BigDecimal actualScore = correct ? defaultScore(question.getQuestionScore()) : ZERO_SCORE;
            answer.setIsCorrect(correct ? "1" : "0");
            answer.setActualScore(actualScore);
            examRuntimeMapper.updateStudentAnswer(answer);
            objectiveScore = objectiveScore.add(actualScore);
        }

        EduExamRecord finishRecord = new EduExamRecord();
        finishRecord.setRecordId(recordId);
        finishRecord.setObjectiveScore(objectiveScore);
        finishRecord.setSubjectiveScore(ZERO_SCORE);
        finishRecord.setTotalScore(objectiveScore);
        finishRecord.setResultStatus(comparePassFlag(objectiveScore, exam.getPassScore()));
        finishRecord.setCheckedFlag(hasManualQuestion ? "0" : "1");
        finishRecord.setRecordStatus(hasManualQuestion ? "2" : "3");
        if (studentLearningMapper.finishExamRecord(finishRecord) <= 0)
        {
            throw new ServiceException("考试记录不存在或已提交");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int importExamWrongQuestions(Long recordId, Long studentId)
    {
        List<StudentExamWrongQuestionVO> wrongQuestions = studentLearningMapper.selectExamWrongQuestionList(recordId, studentId);
        if (wrongQuestions == null || wrongQuestions.isEmpty())
        {
            throw new ServiceException("该试卷暂无可导入的错题");
        }

        StudentProfile profile = studentAccountMapper.selectStudentProfileByUserId(studentId);
        List<Map<String, Object>> storedItems = parseWrongQuestionItems(profile == null ? null : profile.getWrongQuestions());
        Set<String> sourceKeys = collectWrongQuestionSourceKeys(storedItems);
        String importedAt = DateUtils.getTime();
        int importCount = 0;

        for (StudentExamWrongQuestionVO question : wrongQuestions)
        {
            String sourceKey = buildWrongQuestionSourceKey(recordId, question);
            if (sourceKeys.contains(sourceKey))
            {
                continue;
            }
            storedItems.add(0, buildWrongQuestionItem(question, sourceKey, importedAt));
            sourceKeys.add(sourceKey);
            importCount++;
        }

        if (importCount <= 0)
        {
            throw new ServiceException("该试卷错题已全部导入");
        }

        if (profile == null)
        {
            profile = new StudentProfile();
            profile.setUserId(studentId);
            profile.setWrongQuestions(JSON.toJSONString(storedItems));
            studentAccountMapper.insertStudentProfile(profile);
        }
        else
        {
            profile.setWrongQuestions(JSON.toJSONString(storedItems));
            studentAccountMapper.updateStudentProfile(profile);
        }
        return importCount;
    }

    @Override
    public StudentExamResultVO selectStudentExamResult(Long recordId, Long studentId)
    {
        EduExamRecord record = studentLearningMapper.selectExamRecordById(recordId, studentId);
        if (record == null)
        {
            throw new ServiceException("考试记录不存在");
        }
        EduExam exam = examMapper.selectEduExamById(record.getExamId());
        if (exam == null)
        {
            throw new ServiceException("考试不存在");
        }
        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(exam.getExamId());
        List<EduExamAnswer> answerList = examRuntimeMapper.selectExamAnswerListByRecordId(recordId);

        StudentExamResultVO vo = new StudentExamResultVO();
        vo.setRecordId(record.getRecordId());
        vo.setExamId(exam.getExamId());
        vo.setExamName(exam.getExamName());
        vo.setCourseName(exam.getCourseName());
        vo.setPaperName(exam.getPaperName());
        vo.setRecordStartTime(record.getStartTime());
        vo.setSubmitTime(record.getSubmitTime());
        vo.setDurationSeconds(record.getDurationSeconds());
        vo.setRecordStatus(record.getRecordStatus());
        vo.setCheckedFlag(record.getCheckedFlag());
        vo.setResultStatus(record.getResultStatus());
        vo.setShowAnswerAfterSubmit(exam.getShowAnswerAfterSubmit());
        vo.setShowScoreAfterSubmit(exam.getShowScoreAfterSubmit());
        vo.setObjectiveScore(defaultScore(record.getObjectiveScore()));
        vo.setSubjectiveScore(defaultScore(record.getSubjectiveScore()));
        vo.setTotalScore(defaultScore(record.getTotalScore()));
        vo.setPassScore(defaultScore(exam.getPassScore()));
        vo.setQuestionList(buildQuestionVOList(
                questionList,
                answerList,
                "1".equals(exam.getShowAnswerAfterSubmit()),
                "1".equals(exam.getShowScoreAfterSubmit())));
        return vo;
    }

    private EduExam getPublishedExam(Long examId)
    {
        EduExam exam = examMapper.selectEduExamById(examId);
        if (StringUtils.isNull(exam) || !"1".equals(exam.getStatus()))
        {
            throw new ServiceException("考试不存在或尚未发布");
        }
        return exam;
    }

    private EduExamRecord getRunningExamRecord(Long recordId, Long studentId)
    {
        EduExamRecord record = studentLearningMapper.selectExamRecordById(recordId, studentId);
        if (record == null)
        {
            throw new ServiceException("考试记录不存在");
        }
        if (!"1".equals(record.getRecordStatus()))
        {
            throw new ServiceException("当前考试记录已提交，无法继续作答");
        }
        return record;
    }

    private void ensureExamQuestionSnapshot(EduExam exam)
    {
        if (examRuntimeMapper.countExamQuestion(exam.getExamId()) > 0)
        {
            return;
        }
        EduPaper paper = paperMapper.selectEduPaperById(exam.getPaperId());
        if (paper == null)
        {
            throw new ServiceException("考试关联的试卷不存在");
        }

        List<EduQuestion> sourceQuestions = resolvePaperQuestions(paper);
        if (StringUtils.isEmpty(sourceQuestions))
        {
            throw new ServiceException("当前试卷暂无可用题目，无法开始考试");
        }

        List<EduExamQuestion> snapshotList = new ArrayList<>();
        int order = 1;
        for (EduQuestion source : sourceQuestions)
        {
            EduExamQuestion snapshot = new EduExamQuestion();
            snapshot.setExamId(exam.getExamId());
            snapshot.setPaperId(exam.getPaperId());
            snapshot.setQuestionId(source.getQuestionId());
            snapshot.setQuestionType(source.getQuestionType());
            snapshot.setQuestionOrder(order++);
            snapshot.setQuestionScore(defaultScore(source.getScore()));
            snapshot.setDifficultyLevel(source.getDifficultyLevel());
            snapshot.setQuestionTitle(source.getQuestionTitle());
            snapshot.setOptionSnapshot(JSON.toJSONString(source.getOptionList()));
            snapshot.setStandardAnswer(source.getAnswerJson());
            snapshot.setAnalysisSnapshot(source.getAnalysis());
            snapshot.setAttachmentUrl(source.getAttachmentUrl());
            snapshot.setAutoMarking(source.getAutoMarking());
            snapshotList.add(snapshot);
        }
        examRuntimeMapper.batchInsertExamQuestion(snapshotList);
    }

    private List<EduQuestion> resolvePaperQuestions(EduPaper paper)
    {
        List<EduQuestion> result = new ArrayList<>();
        List<EduPaperQuestion> paperQuestionList = paperQuestionMapper.selectPaperQuestionList(paper.getPaperId());
        if (StringUtils.isEmpty(paperQuestionList))
        {
            throw new ServiceException("试卷「" + paper.getPaperName() + "」尚未组卷，无法生成考试题目快照");
        }
        for (EduPaperQuestion relation : paperQuestionList)
        {
            EduQuestion question = questionMapper.selectEduQuestionById(relation.getQuestionId());
            if (question == null || !"1".equals(question.getStatus()))
            {
                continue;
            }
            question.setOptionList(questionMapper.selectOptionListByQuestionId(question.getQuestionId()));
            if (relation.getQuestionScore() != null)
            {
                question.setScore(relation.getQuestionScore());
            }
            result.add(question);
        }
        if (result.isEmpty())
        {
            throw new ServiceException("试卷「" + paper.getPaperName() + "」中所有题目已被删除或停用，无法开始考试");
        }
        return result;
    }

    private void bootstrapExamAnswersIfNeeded(EduExamRecord record)
    {
        if (StringUtils.isNotEmpty(examRuntimeMapper.selectExamAnswerListByRecordId(record.getRecordId())))
        {
            return;
        }
        List<EduExamQuestion> questionList = examRuntimeMapper.selectExamQuestionList(record.getExamId());
        List<EduExamAnswer> answerList = new ArrayList<>();
        for (EduExamQuestion question : questionList)
        {
            EduExamAnswer answer = new EduExamAnswer();
            answer.setRecordId(record.getRecordId());
            answer.setExamId(record.getExamId());
            answer.setQuestionId(question.getQuestionId());
            answer.setQuestionType(question.getQuestionType());
            answer.setQuestionOrder(question.getQuestionOrder());
            answer.setStandardAnswer(question.getStandardAnswer());
            answer.setStudentAnswer("");
            answer.setIsCorrect("0");
            answer.setQuestionScore(defaultScore(question.getQuestionScore()));
            answer.setActualScore(ZERO_SCORE);
            answer.setTeacherComment("");
            answerList.add(answer);
        }
        if (StringUtils.isNotEmpty(answerList))
        {
            examRuntimeMapper.batchInsertExamAnswer(answerList);
        }
    }

    private List<StudentExamQuestionVO> buildQuestionVOList(List<EduExamQuestion> questionList, List<EduExamAnswer> answerList,
            boolean showAnswer, boolean showScore)
    {
        Map<Long, EduExamAnswer> answerMap = new HashMap<>();
        if (answerList != null)
        {
            for (EduExamAnswer answer : answerList)
            {
                answerMap.put(answer.getQuestionId(), answer);
            }
        }

        List<StudentExamQuestionVO> list = new ArrayList<>();
        for (EduExamQuestion question : questionList)
        {
            EduExamAnswer answer = answerMap.get(question.getQuestionId());
            StudentExamQuestionVO vo = new StudentExamQuestionVO();
            vo.setQuestionId(question.getQuestionId());
            vo.setQuestionType(question.getQuestionType());
            vo.setQuestionOrder(question.getQuestionOrder());
            vo.setQuestionScore(defaultScore(question.getQuestionScore()));
            vo.setQuestionTitle(question.getQuestionTitle());
            vo.setAttachmentUrl(question.getAttachmentUrl());
            vo.setOptionList(parseOptionSnapshot(question.getOptionSnapshot()));
            vo.setStudentAnswer(answer == null ? "" : answer.getStudentAnswer());
            vo.setStandardAnswer(showAnswer ? question.getStandardAnswer() : null);
            vo.setAnalysisSnapshot(showAnswer ? question.getAnalysisSnapshot() : null);
            vo.setIsCorrect(showScore && answer != null ? answer.getIsCorrect() : null);
            vo.setActualScore(showScore && answer != null ? defaultScore(answer.getActualScore()) : null);
            list.add(vo);
        }
        return list;
    }

    private List<EduQuestionOption> parseOptionSnapshot(String optionSnapshot)
    {
        if (StringUtils.isEmpty(optionSnapshot))
        {
            return Collections.emptyList();
        }
        return JSON.parseArray(optionSnapshot, EduQuestionOption.class);
    }

    private int calculateRemainingSeconds(EduExamRecord record, EduExam exam)
    {
        int totalSeconds = defaultInt(exam.getDurationMinutes()) * 60;
        if (totalSeconds <= 0 || record.getStartTime() == null)
        {
            return 0;
        }
        long usedSeconds = Math.max(0, (System.currentTimeMillis() - record.getStartTime().getTime()) / 1000);
        long remaining = totalSeconds - usedSeconds;
        return remaining > 0 ? (int) remaining : 0;
    }

    private boolean judgeAnswer(EduExamQuestion question, String studentAnswer)
    {
        String standard = StringUtils.trimToEmpty(question.getStandardAnswer());
        String answer = StringUtils.trimToEmpty(studentAnswer);
        if (StringUtils.isEmpty(answer))
        {
            return false;
        }
        switch (StringUtils.defaultString(question.getQuestionType()))
        {
            case "2":
                return compareMultiAnswer(standard, answer);
            case "4":
                return compareBlankAnswer(standard, answer);
            default:
                return compareSingleAnswer(standard, answer);
        }
    }

    private boolean compareSingleAnswer(String standard, String answer)
    {
        List<String> standards = parseStandardAnswers(standard);
        if (standards.isEmpty())
        {
            return StringUtils.equalsIgnoreCase(standard, answer);
        }
        return StringUtils.equalsIgnoreCase(standards.get(0), answer);
    }

    private boolean compareMultiAnswer(String standard, String answer)
    {
        Set<String> standardSet = new HashSet<>(parseStandardAnswers(standard));
        Set<String> answerSet = new HashSet<>(parseStandardAnswers(answer));
        return !standardSet.isEmpty() && standardSet.equals(answerSet);
    }

    private boolean compareBlankAnswer(String standard, String answer)
    {
        List<String> standards = parseStandardAnswers(standard);
        if (standards.isEmpty())
        {
            standards = splitCommaText(standard);
        }
        for (String item : standards)
        {
            if (StringUtils.equalsIgnoreCase(StringUtils.trim(item), StringUtils.trim(answer)))
            {
                return true;
            }
        }
        return false;
    }

    private List<String> parseStandardAnswers(String text)
    {
        if (StringUtils.isEmpty(text))
        {
            return Collections.emptyList();
        }
        String trim = text.trim();
        if (trim.startsWith("["))
        {
            return JSON.parseArray(trim, String.class);
        }
        return splitCommaText(trim);
    }

    private List<String> splitCommaText(String text)
    {
        if (StringUtils.isEmpty(text))
        {
            return Collections.emptyList();
        }
        String[] parts = text.split(",");
        List<String> result = new ArrayList<>();
        for (String part : parts)
        {
            if (StringUtils.isNotEmpty(part))
            {
                result.add(StringUtils.trim(part));
            }
        }
        return result;
    }

    private String comparePassFlag(BigDecimal score, BigDecimal passScore)
    {
        return defaultScore(score).compareTo(defaultScore(passScore)) >= 0 ? "1" : "0";
    }

    private BigDecimal defaultScore(BigDecimal value)
    {
        return value == null ? ZERO_SCORE : value.setScale(2, RoundingMode.HALF_UP);
    }

    @Override
    public List<CourseDiscussion> selectCourseDiscussionList(Long courseId, Long studentId)
    {
        validateCourseDiscussionAccess(courseId, studentId);
        return studentLearningMapper.selectCourseDiscussionList(courseId);
    }

    @Override
    public List<CourseDiscussion> selectMyCourseDiscussionList(Long studentId)
    {
        return studentLearningMapper.selectMyCourseDiscussionList(studentId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CourseDiscussion addCourseDiscussion(Long courseId, Long studentId, String content)
    {
        validateCourseDiscussionAccess(courseId, studentId);
        String discussionContent = StringUtils.trim(content);
        if (StringUtils.isEmpty(discussionContent))
        {
            throw new ServiceException("讨论内容不能为空");
        }
        if (discussionContent.length() > 1000)
        {
            throw new ServiceException("讨论内容不能超过1000个字符");
        }
        CourseDiscussion discussion = new CourseDiscussion();
        discussion.setCourseId(courseId);
        discussion.setStudentId(studentId);
        discussion.setContent(discussionContent);
        discussion.setStatus("0");
        discussion.setCreateBy(String.valueOf(studentId));
        studentLearningMapper.insertCourseDiscussion(discussion);
        return discussion;
    }

    private void validateExamTime(EduExam exam)
    {
        Date now = new Date();
        if (exam.getStartTime() != null && now.before(exam.getStartTime()))
        {
            throw new ServiceException("考试尚未开始");
        }
        if (exam.getEndTime() != null && now.after(exam.getEndTime()))
        {
            throw new ServiceException("考试已结束");
        }
    }

    private void ensureStudentEnrolled(Long courseId, Long studentId)
    {
        if (courseId == null)
        {
            return;
        }
        if (courseEnrollMapper.selectEduCourseEnroll(courseId, studentId) == null)
        {
            throw new ServiceException("请先注册该课程再参加考试");
        }
    }

    /**
     * 考试多课程注册检查：学生在任意一个关联课程中注册即可
     */
    private void ensureStudentEnrolledForExam(EduExam exam, Long studentId)
    {
        java.util.Set<Long> courseIds = new java.util.LinkedHashSet<>();
        if (exam.getCourseId() != null)
        {
            courseIds.add(exam.getCourseId());
        }
        List<Long> multiCourseIds = examMapper.selectCourseIdsByExamId(exam.getExamId());
        if (multiCourseIds != null)
        {
            courseIds.addAll(multiCourseIds);
        }
        if (courseIds.isEmpty())
        {
            return;
        }
        for (Long courseId : courseIds)
        {
            if (courseEnrollMapper.selectEduCourseEnroll(courseId, studentId) != null)
            {
                return;
            }
        }
        throw new ServiceException("请先注册考试关联的课程再参加考试");
    }

    private int defaultInt(Integer value)
    {
        return value == null ? 0 : value;
    }

    private void validateCourseDiscussionAccess(Long courseId, Long studentId)
    {
        if (courseId == null)
        {
            throw new ServiceException("课程不存在");
        }
        if (courseMapper.selectPublishedCourseById(courseId) == null)
        {
            throw new ServiceException("课程不存在或尚未发布");
        }
        ensureStudentEnrolled(courseId, studentId);
    }

    private List<Map<String, Object>> parseWrongQuestionItems(String raw)
    {
        List<Map<String, Object>> items = new ArrayList<>();
        if (StringUtils.isEmpty(raw))
        {
            return items;
        }
        try
        {
            Object parsed = JSON.parse(raw);
            if (parsed instanceof JSONArray)
            {
                appendWrongQuestionItems(items, (JSONArray) parsed);
            }
            else if (parsed instanceof JSONObject)
            {
                Object nestedItems = ((JSONObject) parsed).get("items");
                if (nestedItems instanceof JSONArray)
                {
                    appendWrongQuestionItems(items, (JSONArray) nestedItems);
                }
            }
        }
        catch (Exception e)
        {
            Map<String, Object> legacyItem = new LinkedHashMap<>();
            legacyItem.put("id", "wrong-legacy-" + System.currentTimeMillis());
            legacyItem.put("title", "历史记录");
            legacyItem.put("detail", raw);
            legacyItem.put("summary", raw);
            List<String> tags = new ArrayList<>();
            tags.add("历史文本");
            legacyItem.put("tags", tags);
            items.add(legacyItem);
        }
        return items;
    }

    @SuppressWarnings("unchecked")
    private void appendWrongQuestionItems(List<Map<String, Object>> items, JSONArray array)
    {
        for (Object item : array)
        {
            if (item instanceof Map)
            {
                items.add(new LinkedHashMap<>((Map<String, Object>) item));
            }
        }
    }

    private Set<String> collectWrongQuestionSourceKeys(List<Map<String, Object>> storedItems)
    {
        Set<String> sourceKeys = new HashSet<>();
        for (Map<String, Object> item : storedItems)
        {
            Object sourceKey = item.get("sourceKey");
            if (sourceKey != null)
            {
                sourceKeys.add(String.valueOf(sourceKey));
            }
            Object id = item.get("id");
            if (id != null)
            {
                sourceKeys.add(String.valueOf(id));
            }
        }
        return sourceKeys;
    }

    private String buildWrongQuestionSourceKey(Long recordId, StudentExamWrongQuestionVO question)
    {
        Long questionKey = question.getQuestionId() == null ? question.getAnswerId() : question.getQuestionId();
        return "exam-record-" + recordId + "-question-" + questionKey;
    }

    private Map<String, Object> buildWrongQuestionItem(StudentExamWrongQuestionVO question, String sourceKey, String importedAt)
    {
        String title = createWrongQuestionTitle(question.getQuestionTitle());
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("id", "exam-wrong-" + question.getRecordId() + "-" + (question.getQuestionId() == null ? question.getAnswerId() : question.getQuestionId()));
        item.put("sourceKey", sourceKey);
        item.put("sourceType", "exam");
        item.put("recordId", question.getRecordId());
        item.put("examId", question.getExamId());
        item.put("paperId", question.getPaperId());
        item.put("courseId", question.getCourseId());
        item.put("title", title);
        item.put("courseName", question.getCourseName());
        item.put("contentTitle", question.getExamName());
        item.put("chapterTitle", question.getPaperName());
        item.put("questionStem", question.getQuestionTitle());
        item.put("questionImage", question.getAttachmentUrl());
        item.put("myAnswer", formatAnswer(question.getStudentAnswer()));
        item.put("correctAnswer", formatAnswer(question.getStandardAnswer()));
        item.put("analysis", question.getAnalysis());
        item.put("summary", question.getQuestionTitle());
        item.put("detail", buildWrongQuestionDetail(question));
        item.put("collectedAt", importedAt);
        item.put("createdAt", importedAt);
        item.put("updatedAt", importedAt);

        List<String> tags = new ArrayList<>();
        tags.add("考试错题");
        if (StringUtils.isNotEmpty(question.getQuestionType()))
        {
            tags.add("题型" + question.getQuestionType());
        }
        item.put("tags", tags);
        return item;
    }

    private String createWrongQuestionTitle(String questionTitle)
    {
        if (StringUtils.isEmpty(questionTitle))
        {
            return "考试错题";
        }
        String value = questionTitle.trim();
        return value.length() > 28 ? value.substring(0, 28) + "..." : value;
    }

    private String formatAnswer(String answer)
    {
        if (StringUtils.isEmpty(answer))
        {
            return "";
        }
        try
        {
            Object parsed = JSON.parse(answer);
            if (parsed instanceof JSONArray)
            {
                List<String> values = new ArrayList<>();
                for (Object value : (JSONArray) parsed)
                {
                    values.add(String.valueOf(value));
                }
                return String.join("、", values);
            }
            if (parsed instanceof JSONObject)
            {
                return JSON.toJSONString(parsed);
            }
        }
        catch (Exception e)
        {
            return answer;
        }
        return answer;
    }

    private String buildWrongQuestionDetail(StudentExamWrongQuestionVO question)
    {
        List<String> lines = new ArrayList<>();
        if (StringUtils.isNotEmpty(question.getExamName()))
        {
            lines.add("来源考试：" + question.getExamName());
        }
        if (StringUtils.isNotEmpty(question.getPaperName()))
        {
            lines.add("试卷：" + question.getPaperName());
        }
        if (question.getActualScore() != null || question.getQuestionScore() != null)
        {
            lines.add("得分：" + formatScore(question.getActualScore()) + " / " + formatScore(question.getQuestionScore()));
        }
        if (StringUtils.isNotEmpty(question.getTeacherComment()))
        {
            lines.add("教师评语：" + question.getTeacherComment());
        }
        return String.join("\n", lines);
    }

    private String formatScore(BigDecimal score)
    {
        return score == null ? "0" : score.stripTrailingZeros().toPlainString();
    }
}
