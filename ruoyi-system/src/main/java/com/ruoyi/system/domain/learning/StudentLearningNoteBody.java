package com.ruoyi.system.domain.learning;

/**
 * 学生课程内容笔记提交对象
 *
 * @author ruoyi
 */
public class StudentLearningNoteBody
{
    /** 笔记标题 */
    private String title;

    /** 笔记内容 */
    private String content;

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }
}
