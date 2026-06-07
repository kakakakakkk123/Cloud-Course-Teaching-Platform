package com.ruoyi.common.utils;

/**
 * Password policy validation helpers.
 */
public class PasswordPolicyUtils
{
    private static final String ILLEGAL_CHARS = "<>\"'|\\";
    private static final String SYMBOLS = "~!@#$%^&*()-=_+";

    public static String validate(String password, int minLength, int maxLength, String chrtype)
    {
        if (StringUtils.isEmpty(password))
        {
            return "密码不能为空";
        }
        if (password.length() < minLength || password.length() > maxLength)
        {
            return "密码长度必须在" + minLength + "到" + maxLength + "个字符之间";
        }
        if (containsAny(password, ILLEGAL_CHARS))
        {
            return "密码不能包含非法字符：" + ILLEGAL_CHARS;
        }
        String type = StringUtils.isEmpty(chrtype) ? "0" : chrtype;
        if ("1".equals(type) && !password.matches("^[0-9]+$"))
        {
            return "密码只能为数字（0-9）";
        }
        if ("2".equals(type) && !password.matches("^[a-zA-Z]+$"))
        {
            return "密码只能为英文字母（a-z、A-Z）";
        }
        if ("3".equals(type) && (!password.matches(".*[a-zA-Z].*") || !password.matches(".*[0-9].*")
                || !password.matches("^[a-zA-Z0-9]+$")))
        {
            return "密码必须同时包含字母和数字";
        }
        if ("4".equals(type) && (!password.matches(".*[a-zA-Z].*") || !password.matches(".*[0-9].*")
                || !containsAny(password, SYMBOLS) || !password.matches("^[A-Za-z0-9~!@#$%^&*()\\-=_+]+$")))
        {
            return "密码必须同时包含字母、数字和特殊字符（" + SYMBOLS + "）";
        }
        return null;
    }

    private static boolean containsAny(String value, String chars)
    {
        if (StringUtils.isEmpty(value) || StringUtils.isEmpty(chars))
        {
            return false;
        }
        for (int i = 0; i < chars.length(); i++)
        {
            if (value.indexOf(chars.charAt(i)) >= 0)
            {
                return true;
            }
        }
        return false;
    }
}
