package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
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
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduQuestionOption;
import com.ruoyi.system.domain.learning.StudentExamQuestionVO;
import com.ruoyi.system.domain.learning.StudentExamVO;
import com.ruoyi.system.domain.learning.StudentExamWrongQuestionVO;
import com.ruoyi.system.domain.learning.StudentLearningOverview;
import com.ruoyi.system.mapper.EduCourseContentMapper;
import com.ruoyi.system.mapper.EduCourseEnrollMapper;
import com.ruoyi.system.mapper.EduExamMapper;
import com.ruoyi.system.mapper.EduQuestionMapper;
import com.ruoyi.system.mapper.StudentAccountMapper;
import com.ruoyi.system.mapper.StudentLearningMapper;
import com.ruoyi.system.service.IEduStudentLearningService;

/**
 * 学生学习服务实现
 *
 * @author ruoyi
 */
@Service
public class EduStudentLearningServiceImpl implements IEduStudentLearningService
{
    @Autowired
    private StudentLearningMapper studentLearningMapper;

    @Autowired
    private EduCourseContentMapper courseContentMapper;

    @Autowired
    private EduCourseEnrollMapper courseEnrollMapper;

    @Autowired
    private EduExamMapper examMapper;

    @Autowired
    private EduQuestionMapper questionMapper;

    @Autowired
    private StudentAccountMapper studentAccountMapper;

    /**
     * 查询学习概览
     */
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

    /**
     * 查询学生考试列表
     */
    @Override
    public List<StudentExamVO> selectStudentExamList(Long studentId, String status)
    {
        return studentLearningMapper.selectStudentExamList(studentId, status);
    }

    /**
     * 标记课程内容已学习
     */
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

    /**
     * 开始考试
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public EduExamRecord startExam(Long examId, Long studentId)
    {
        EduExam exam = examMapper.selectEduExamById(examId);
        if (StringUtils.isNull(exam) || !"1".equals(exam.getStatus()))
        {
            throw new ServiceException("考试不存在或尚未发布");
        }
        validateExamTime(exam);
        ensureStudentEnrolled(exam.getCourseId(), studentId);

        EduExamRecord runningRecord = studentLearningMapper.selectRunningExamRecord(examId, studentId);
        if (runningRecord != null)
        {
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
        return record;
    }

    /**
     * 查询考试作答内容
     */
    @Override
    public Map<String, Object> selectExamContent(Long recordId, Long studentId)
    {
        StudentExamVO exam = studentLearningMapper.selectStudentExamByRecordId(recordId, studentId);
        if (exam == null)
        {
            throw new ServiceException("考试记录不存在");
        }
        if (!"1".equals(exam.getRecordStatus()))
        {
            throw new ServiceException("考试记录不在作答中");
        }
        List<StudentExamQuestionVO> questions = studentLearningMapper.selectExamQuestionList(recordId, studentId);
        for (StudentExamQuestionVO question : questions)
        {
            List<EduQuestionOption> options = questionMapper.selectOptionListByQuestionId(question.getQuestionId());
            for (EduQuestionOption option : options)
            {
                option.setIsCorrect(null);
            }
            question.setOptionList(options);
        }
        Map<String, Object> content = new LinkedHashMap<>();
        content.put("exam", exam);
        content.put("questions", questions);
        return content;
    }

    /**
     * 提交考试
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void submitExam(Long recordId, Long studentId)
    {
        if (studentLearningMapper.submitExamRecord(recordId, studentId) <= 0)
        {
            throw new ServiceException("考试记录不存在或已提交");
        }
    }

    /**
     * 将考试错题导入我的错题
     */
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

    private int defaultInt(Integer value)
    {
        return value == null ? 0 : value;
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
            lines.add("得分：" + defaultScore(question.getActualScore()) + " / " + defaultScore(question.getQuestionScore()));
        }
        if (StringUtils.isNotEmpty(question.getTeacherComment()))
        {
            lines.add("教师评语：" + question.getTeacherComment());
        }
        return String.join("\n", lines);
    }

    private String defaultScore(BigDecimal score)
    {
        return score == null ? "0" : score.stripTrailingZeros().toPlainString();
    }
}
