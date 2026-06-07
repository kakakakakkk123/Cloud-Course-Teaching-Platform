package com.ruoyi.common.core.domain.model;

/**
 * 账户安全配置
 */
public class AccountSecuritySettings
{
    private String blackIpList;

    private String blockedUserAgentKeywords;

    private Boolean forgotPasswordEmailRequired;

    public String getBlackIpList()
    {
        return blackIpList;
    }

    public void setBlackIpList(String blackIpList)
    {
        this.blackIpList = blackIpList;
    }

    public String getBlockedUserAgentKeywords()
    {
        return blockedUserAgentKeywords;
    }

    public void setBlockedUserAgentKeywords(String blockedUserAgentKeywords)
    {
        this.blockedUserAgentKeywords = blockedUserAgentKeywords;
    }

    public Boolean getForgotPasswordEmailRequired()
    {
        return forgotPasswordEmailRequired;
    }

    public void setForgotPasswordEmailRequired(Boolean forgotPasswordEmailRequired)
    {
        this.forgotPasswordEmailRequired = forgotPasswordEmailRequired;
    }
}
