package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduExamStatOverview;

/**
 * 考试统计数据层
 *
 * @author ruoyi
 */
public interface EduExamStatMapper
{
    /**
     * 查询考试统计概览
     *
     * @param examId 考试ID
     * @return 统计概览
     */
    public EduExamStatOverview selectExamStatOverview(Long examId);

    /**
     * 查询考试成绩列表
     *
     * @param record 查询条件
     * @return 成绩记录集合
     */
    public List<EduExamRecord> selectExamStatRecordList(EduExamRecord record);

    public EduExamRecord selectExamStatRecordById(Long recordId);
}
