<template>
  <div class="app-container system-settings">
    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="注册设置" name="register">
        <el-form label-width="180px" size="small">
          <el-form-item label="学生自主注册">
            <el-switch
              v-model="registerEnabled"
              active-text="允许"
              inactive-text="关闭"
              @change="handleRegisterToggle"
            />
          </el-form-item>
          <el-form-item label="找回密码邮箱校验">
            <el-switch
              v-model="securitySettings.forgotPasswordEmailRequired"
              active-text="强制校验"
              inactive-text="可选校验"
            />
          </el-form-item>
          <el-form-item label="学生默认账号状态">
            <el-radio-group v-model="accountPolicy.studentDefaultStatus">
              <el-radio label="0">正常</el-radio>
              <el-radio label="1">停用，待教师启用</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="导入名单外账号策略">
            <el-radio-group v-model="accountPolicy.missingStudentPolicy">
              <el-radio label="ignore">仅提示</el-radio>
              <el-radio label="disable">自动停用</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>
      </el-tab-pane>

      <el-tab-pane label="登录安全" name="security">
        <el-form label-width="180px" size="small">
          <el-form-item label="登录 IP 黑名单">
            <el-input
              v-model="securitySettings.blackIpList"
              type="textarea"
              :rows="4"
              placeholder="支持单个 IP、通配符和 IP 段，多个条目可用分号或换行分隔"
            />
          </el-form-item>
          <el-form-item label="终端关键字黑名单">
            <el-input
              v-model="securitySettings.blockedUserAgentKeywords"
              type="textarea"
              :rows="4"
              placeholder="例如 Android、iPhone、MicroMessenger、kiosk"
            />
          </el-form-item>
          <el-form-item label="记录设备号 / MAC">
            <el-switch v-model="securitySettings.recordDeviceInfo" active-text="记录" inactive-text="不记录" />
            <span class="form-tip">浏览器无法直接读取真实 MAC，可记录客户端传入的 X-Device-Id 或 X-Mac-Address。</span>
          </el-form-item>
          <el-form-item label="失败锁定策略">
            <el-input-number v-model="securitySettings.maxRetryCount" :min="1" :max="20" />
            <span class="inline-label">次失败后锁定</span>
            <el-input-number v-model="securitySettings.lockTime" :min="1" :max="1440" />
            <span class="inline-label">分钟</span>
          </el-form-item>
        </el-form>
      </el-tab-pane>

      <el-tab-pane label="密码策略" name="password">
        <el-form label-width="180px" size="small">
          <el-form-item label="默认初始密码">
            <el-input v-model.trim="accountPolicy.initPassword" show-password maxlength="20" />
          </el-form-item>
          <el-form-item label="密码长度">
            <el-input-number v-model="accountPolicy.passwordMinLength" :min="5" :max="20" />
            <span class="inline-label">到</span>
            <el-input-number v-model="accountPolicy.passwordMaxLength" :min="5" :max="50" />
            <span class="inline-label">个字符</span>
          </el-form-item>
          <el-form-item label="复杂度要求">
            <el-checkbox v-model="accountPolicy.passwordNeedLetter">包含字母</el-checkbox>
            <el-checkbox v-model="accountPolicy.passwordNeedNumber">包含数字</el-checkbox>
            <el-checkbox v-model="accountPolicy.passwordNeedSymbol">包含特殊字符</el-checkbox>
          </el-form-item>
        </el-form>
      </el-tab-pane>

      <el-tab-pane label="审计策略" name="audit">
        <el-form label-width="180px" size="small">
          <el-form-item label="登录审计保留天数">
            <el-input-number v-model="auditPolicy.loginLogRetentionDays" :min="7" :max="3650" />
          </el-form-item>
          <el-form-item label="操作审计保留天数">
            <el-input-number v-model="auditPolicy.operLogRetentionDays" :min="7" :max="3650" />
          </el-form-item>
          <el-form-item label="失败原因记录">
            <el-switch v-model="auditPolicy.recordFailureReason" active-text="记录" inactive-text="不记录" />
          </el-form-item>
          <el-form-item label="导出审计">
            <el-switch v-model="auditPolicy.auditExportEnabled" active-text="允许" inactive-text="关闭" />
          </el-form-item>
        </el-form>
      </el-tab-pane>
    </el-tabs>

    <div class="settings-footer">
      <el-button type="primary" icon="el-icon-check" @click="handleSaveAll">保存设置</el-button>
      <el-button icon="el-icon-refresh" @click="loadSettings">刷新</el-button>
    </div>
  </div>
</template>

<script>
import { getRegisterEnabled, setRegisterEnabled, getSecuritySettings, updateSecuritySettings } from "@/api/account"
import { getConfigKey, updateConfig, addConfig, listConfig } from "@/api/system/config"

const CONFIG_KEYS = {
  initPassword: "sys.user.initPassword",
  chrtype: "sys.account.chrtype",
  studentDefaultStatus: "sys.account.studentDefaultStatus",
  missingStudentPolicy: "sys.account.missingStudentPolicy",
  passwordMinLength: "sys.account.passwordMinLength",
  passwordMaxLength: "sys.account.passwordMaxLength",
  passwordNeedLetter: "sys.account.passwordNeedLetter",
  passwordNeedNumber: "sys.account.passwordNeedNumber",
  passwordNeedSymbol: "sys.account.passwordNeedSymbol",
  loginLogRetentionDays: "sys.audit.loginLogRetentionDays",
  operLogRetentionDays: "sys.audit.operLogRetentionDays",
  recordFailureReason: "sys.audit.recordFailureReason",
  auditExportEnabled: "sys.audit.exportEnabled",
  maxRetryCount: "sys.login.maxRetryCount",
  lockTime: "sys.login.lockTime",
  recordDeviceInfo: "sys.login.recordDeviceInfo"
}

export default {
  name: "SystemSettings",
  data() {
    return {
      activeTab: "register",
      registerEnabled: false,
      securitySettings: {
        blackIpList: "",
        blockedUserAgentKeywords: "",
        forgotPasswordEmailRequired: false,
        recordDeviceInfo: true,
        maxRetryCount: 5,
        lockTime: 10
      },
      accountPolicy: {
        studentDefaultStatus: "0",
        missingStudentPolicy: "ignore",
        initPassword: "admin123",
        passwordMinLength: 5,
        passwordMaxLength: 20,
        passwordNeedLetter: true,
        passwordNeedNumber: true,
        passwordNeedSymbol: false
      },
      auditPolicy: {
        loginLogRetentionDays: 180,
        operLogRetentionDays: 180,
        recordFailureReason: true,
        auditExportEnabled: true
      },
      configRecords: {}
    }
  },
  created() {
    this.loadSettings()
  },
  methods: {
    loadSettings() {
      getRegisterEnabled().then(res => {
        this.registerEnabled = !!res.data
      })
      getSecuritySettings().then(res => {
        this.securitySettings = {
          ...this.securitySettings,
          ...(res.data || {})
        }
        this.securitySettings.forgotPasswordEmailRequired = !!this.securitySettings.forgotPasswordEmailRequired
      })
      Promise.all(Object.values(CONFIG_KEYS).map(key => this.loadConfigRecord(key))).then(() => {
        this.applyConfigValues()
      })
    },
    loadConfigRecord(key) {
      return listConfig({ configKey: key }).then(res => {
        const record = (res.rows || [])[0]
        if (record) {
          this.$set(this.configRecords, key, record)
        }
        return getConfigKey(key).then(valueRes => {
          if (!this.configRecords[key]) {
            this.$set(this.configRecords, key, { configKey: key, configValue: valueRes.msg })
          } else {
            this.configRecords[key].configValue = valueRes.msg
          }
        }).catch(() => {})
      })
    },
    applyConfigValues() {
      const value = (key, fallback) => {
        const record = this.configRecords[key]
        return record && record.configValue !== undefined && record.configValue !== "" ? record.configValue : fallback
      }
      this.accountPolicy.initPassword = value(CONFIG_KEYS.initPassword, this.accountPolicy.initPassword)
      this.accountPolicy.studentDefaultStatus = value(CONFIG_KEYS.studentDefaultStatus, this.accountPolicy.studentDefaultStatus)
      this.accountPolicy.missingStudentPolicy = value(CONFIG_KEYS.missingStudentPolicy, this.accountPolicy.missingStudentPolicy)
      this.accountPolicy.passwordMinLength = Number(value(CONFIG_KEYS.passwordMinLength, this.accountPolicy.passwordMinLength))
      this.accountPolicy.passwordMaxLength = Number(value(CONFIG_KEYS.passwordMaxLength, this.accountPolicy.passwordMaxLength))
      this.accountPolicy.passwordNeedLetter = value(CONFIG_KEYS.passwordNeedLetter, "true") === "true"
      this.accountPolicy.passwordNeedNumber = value(CONFIG_KEYS.passwordNeedNumber, "true") === "true"
      this.accountPolicy.passwordNeedSymbol = value(CONFIG_KEYS.passwordNeedSymbol, "false") === "true"
      this.applyChrtype(value(CONFIG_KEYS.chrtype, this.currentChrtype()))
      this.auditPolicy.loginLogRetentionDays = Number(value(CONFIG_KEYS.loginLogRetentionDays, this.auditPolicy.loginLogRetentionDays))
      this.auditPolicy.operLogRetentionDays = Number(value(CONFIG_KEYS.operLogRetentionDays, this.auditPolicy.operLogRetentionDays))
      this.auditPolicy.recordFailureReason = value(CONFIG_KEYS.recordFailureReason, "true") === "true"
      this.auditPolicy.auditExportEnabled = value(CONFIG_KEYS.auditExportEnabled, "true") === "true"
      this.securitySettings.maxRetryCount = Number(value(CONFIG_KEYS.maxRetryCount, this.securitySettings.maxRetryCount))
      this.securitySettings.lockTime = Number(value(CONFIG_KEYS.lockTime, this.securitySettings.lockTime))
      this.securitySettings.recordDeviceInfo = value(CONFIG_KEYS.recordDeviceInfo, "true") === "true"
    },
    currentChrtype() {
      if (this.accountPolicy.passwordNeedSymbol) {
        return "4"
      }
      if (this.accountPolicy.passwordNeedLetter && this.accountPolicy.passwordNeedNumber) {
        return "3"
      }
      if (this.accountPolicy.passwordNeedLetter) {
        return "2"
      }
      if (this.accountPolicy.passwordNeedNumber) {
        return "1"
      }
      return "0"
    },
    applyChrtype(chrtype) {
      const value = String(chrtype || "0")
      this.accountPolicy.passwordNeedLetter = ["2", "3", "4"].includes(value)
      this.accountPolicy.passwordNeedNumber = ["1", "3", "4"].includes(value)
      this.accountPolicy.passwordNeedSymbol = value === "4"
    },
    handleRegisterToggle(value) {
      setRegisterEnabled(value ? "0" : "1").then(() => {
        this.$modal.msgSuccess(value ? "学生自主注册已开启" : "学生自主注册已关闭")
      }).catch(() => {
        this.registerEnabled = !value
      })
    },
    upsertConfig(key, value, name) {
      const record = this.configRecords[key]
      const payload = {
        ...(record || {}),
        configName: (record && record.configName) || name || key,
        configKey: key,
        configValue: String(value),
        configType: "N"
      }
      return payload.configId ? updateConfig(payload) : addConfig(payload)
    },
    handleSaveAll() {
      const securityPayload = {
        blackIpList: this.securitySettings.blackIpList,
        blockedUserAgentKeywords: this.securitySettings.blockedUserAgentKeywords,
        forgotPasswordEmailRequired: this.securitySettings.forgotPasswordEmailRequired
      }
      Promise.all([
        updateSecuritySettings(securityPayload),
        this.upsertConfig(CONFIG_KEYS.initPassword, this.accountPolicy.initPassword, "用户初始密码"),
        this.upsertConfig(CONFIG_KEYS.chrtype, this.currentChrtype(), "密码复杂度规则"),
        this.upsertConfig(CONFIG_KEYS.studentDefaultStatus, this.accountPolicy.studentDefaultStatus, "学生默认账号状态"),
        this.upsertConfig(CONFIG_KEYS.missingStudentPolicy, this.accountPolicy.missingStudentPolicy, "学生名单外账号策略"),
        this.upsertConfig(CONFIG_KEYS.passwordMinLength, this.accountPolicy.passwordMinLength, "密码最小长度"),
        this.upsertConfig(CONFIG_KEYS.passwordMaxLength, this.accountPolicy.passwordMaxLength, "密码最大长度"),
        this.upsertConfig(CONFIG_KEYS.passwordNeedLetter, this.accountPolicy.passwordNeedLetter, "密码要求字母"),
        this.upsertConfig(CONFIG_KEYS.passwordNeedNumber, this.accountPolicy.passwordNeedNumber, "密码要求数字"),
        this.upsertConfig(CONFIG_KEYS.passwordNeedSymbol, this.accountPolicy.passwordNeedSymbol, "密码要求特殊字符"),
        this.upsertConfig(CONFIG_KEYS.loginLogRetentionDays, this.auditPolicy.loginLogRetentionDays, "登录审计保留天数"),
        this.upsertConfig(CONFIG_KEYS.operLogRetentionDays, this.auditPolicy.operLogRetentionDays, "操作审计保留天数"),
        this.upsertConfig(CONFIG_KEYS.recordFailureReason, this.auditPolicy.recordFailureReason, "记录登录失败原因"),
        this.upsertConfig(CONFIG_KEYS.auditExportEnabled, this.auditPolicy.auditExportEnabled, "允许导出审计"),
        this.upsertConfig(CONFIG_KEYS.maxRetryCount, this.securitySettings.maxRetryCount, "登录失败锁定次数"),
        this.upsertConfig(CONFIG_KEYS.lockTime, this.securitySettings.lockTime, "登录失败锁定分钟"),
        this.upsertConfig(CONFIG_KEYS.recordDeviceInfo, this.securitySettings.recordDeviceInfo, "记录登录设备信息")
      ]).then(() => {
        this.$modal.msgSuccess("系统设置已保存")
        this.loadSettings()
      })
    }
  }
}
</script>

<style scoped lang="scss">
.system-settings {
  max-width: 1180px;
}

.form-tip {
  margin-left: 12px;
  color: #909399;
  font-size: 12px;
}

.inline-label {
  margin: 0 8px;
  color: #606266;
}

.settings-footer {
  margin-top: 16px;
  padding: 14px 0;
}
</style>
