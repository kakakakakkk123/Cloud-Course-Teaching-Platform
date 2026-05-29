package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.exam.EduExamRecord;
import com.ruoyi.system.domain.exam.EduExamStatOverview;
import com.ruoyi.system.mapper.EduExamStatMapper;
import com.ruoyi.system.service.IEduExamStatService;

/**
 * 考试统计服务实现
 *
 * @author ruoyi
 */
@Service
public class EduExamStatServiceImpl implements IEduExamStatService
{
    @Autowired
    private EduExamStatMapper examStatMapper;

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
}
