package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.exam.EduExam;

/**
 * 考试服务层
 *
 * @author ruoyi
 */
public interface IEduExamService
{
    public EduExam selectEduExamById(Long examId);

    public List<EduExam> selectEduExamList(EduExam exam);

    public int insertEduExam(EduExam exam);

    public int updateEduExam(EduExam exam);

    public int deleteEduExamByIds(Long[] examIds);
}
