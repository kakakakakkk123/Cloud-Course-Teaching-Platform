package com.ruoyi.common.core.domain.model;

/**
 * 用户注册对象
 * 
 * @author ruoyi
 */
public class RegisterBody extends LoginBody
{
    /**
     * 学号
     */
    private String studentNo;

    /**
     * 昵称
     */
    private String nickName;

    /**
     * 年级
     */
    private String grade;

    private String sex;

    /**
     * 学院ID
     */
    private Long academyId;

    /**
     * 专业ID
     */
    private Long majorId;

    private Long classId;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 手机号
     */
    private String phonenumber;

    private String emailCode;

    public String getStudentNo()
    {
        return studentNo;
    }

    public void setStudentNo(String studentNo)
    {
        this.studentNo = studentNo;
    }

    public String getNickName()
    {
        return nickName;
    }

    public void setNickName(String nickName)
    {
        this.nickName = nickName;
    }

    public String getGrade()
    {
        return grade;
    }

    public void setGrade(String grade)
    {
        this.grade = grade;
    }

    public String getSex()
    {
        return sex;
    }

    public void setSex(String sex)
    {
        this.sex = sex;
    }

    public String getEmail()
    {
        return email;
    }

    public Long getAcademyId()
    {
        return academyId;
    }

    public void setAcademyId(Long academyId)
    {
        this.academyId = academyId;
    }

    public Long getMajorId()
    {
        return majorId;
    }

    public void setMajorId(Long majorId)
    {
        this.majorId = majorId;
    }

    public Long getClassId()
    {
        return classId;
    }

    public void setClassId(Long classId)
    {
        this.classId = classId;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getPhonenumber()
    {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber)
    {
        this.phonenumber = phonenumber;
    }

    public String getEmailCode()
    {
        return emailCode;
    }

    public void setEmailCode(String emailCode)
    {
        this.emailCode = emailCode;
    }

}
