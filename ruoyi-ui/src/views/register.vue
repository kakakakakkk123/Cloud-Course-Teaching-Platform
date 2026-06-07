<template>
  <div class="register-page">
    <div class="register-shell">
      <section class="register-story">
        <div class="story-top">
          <p class="story-kicker">Student Access</p>
          <h1 class="story-title">进入你的课程空间，从一次清晰的注册开始。</h1>
          <p class="story-copy">
            选择学院与专业，创建学生账号，随后即可进入课程、作业、学习记录与个人中心。
          </p>
        </div>

        <div class="story-orbit story-orbit-a" />
        <div class="story-orbit story-orbit-b" />

        <div class="story-panel">
          <div class="story-panel__label">注册流程</div>
          <div
            v-for="item in registerSteps"
            :key="item.title"
            class="story-step"
          >
            <span class="story-step__index">{{ item.index }}</span>
            <div>
              <div class="story-step__title">{{ item.title }}</div>
              <div class="story-step__desc">{{ item.desc }}</div>
            </div>
          </div>
        </div>

        <div class="story-highlights">
          <div
            v-for="item in highlights"
            :key="item.label"
            class="highlight-item"
          >
            <span class="highlight-item__value">{{ item.value }}</span>
            <span class="highlight-item__label">{{ item.label }}</span>
          </div>
        </div>
      </section>

      <section class="register-panel">
        <div class="register-panel__head">
          <p class="eyebrow">学生自主注册</p>
          <h3 class="title">{{ title }}</h3>
          <p class="subtitle">填写基础信息后即可完成账号创建。</p>
        </div>

        <el-alert
          title="填写说明"
          type="info"
          :closable="false"
          description="请准备好学号、学院、专业、年级、手机号与登录密码。"
          show-icon
          class="register-alert"
        />
        <el-alert
          v-if="!registerEnabled"
          title="当前未开放学生自主注册"
          type="warning"
          :closable="false"
          show-icon
          class="register-alert"
        />

        <el-form ref="registerForm" :model="registerForm" :rules="registerRules" class="register-form">
          <div class="form-grid">
            <el-form-item prop="username">
              <el-input v-model.trim="registerForm.username" placeholder="登录账号（可填写学号）">
                <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>

            <el-form-item prop="studentNo">
              <el-input v-model.trim="registerForm.studentNo" placeholder="学号" @blur="handleStudentNoBlur">
                <svg-icon slot="prefix" icon-class="number" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>

            <el-form-item prop="nickName">
              <el-input v-model.trim="registerForm.nickName" placeholder="昵称">
                <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>

            <el-form-item prop="phonenumber">
              <el-input v-model.trim="registerForm.phonenumber" placeholder="手机号">
                <svg-icon slot="prefix" icon-class="phone" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>

            <el-form-item prop="email">
              <el-input v-model.trim="registerForm.email" placeholder="邮箱（可选）">
                <svg-icon slot="prefix" icon-class="email" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>

            <el-form-item v-if="registerForm.email" prop="emailCode">
              <div class="captcha-row">
                <el-input v-model.trim="registerForm.emailCode" placeholder="邮箱验证码">
                  <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
                </el-input>
                <el-button :loading="emailCodeSending" :disabled="emailCodeCountdown > 0" @click="handleSendEmailCode">
                  {{ emailCodeButtonText }}
                </el-button>
              </div>
            </el-form-item>

            <el-form-item prop="academyId">
              <el-select
                v-model="registerForm.academyId"
                placeholder="请选择学院"
                style="width: 100%"
                filterable
                @change="handleAcademyChange"
              >
                <el-option
                  v-for="item in academyOptions"
                  :key="item.id"
                  :label="item.label"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>

            <el-form-item prop="majorId">
              <el-select
                v-model="registerForm.majorId"
                placeholder="请选择专业"
                style="width: 100%"
                filterable
                :disabled="!registerForm.academyId"
              >
                <el-option
                  v-for="item in majorOptions"
                  :key="item.id"
                  :label="item.label"
                  :value="item.id"
                />
              </el-select>
            </el-form-item>

            <el-form-item prop="grade">
              <el-select v-model="registerForm.grade" placeholder="请选择年级" style="width: 100%">
                <el-option
                  v-for="item in gradeOptions"
                  :key="item"
                  :label="item"
                  :value="item"
                />
              </el-select>
            </el-form-item>

            <el-form-item prop="password" :rules="registerPwdValidator">
              <el-input
                v-model="registerForm.password"
                type="password"
                show-password
                placeholder="密码"
                @keyup.enter.native="handleRegister"
              >
                <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
              </el-input>
            </el-form-item>
          </div>

          <el-form-item prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              show-password
              placeholder="确认密码"
              @keyup.enter.native="handleRegister"
            >
              <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>

          <el-form-item v-if="captchaEnabled" prop="code">
            <div class="captcha-row">
              <el-input
                v-model.trim="registerForm.code"
                placeholder="验证码"
                @keyup.enter.native="handleRegister"
              >
                <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
              </el-input>
              <img :src="codeUrl" class="register-code-img" @click="getCode" />
            </div>
          </el-form-item>

          <div class="form-tip">
            可直接使用学号作为登录账号；填写邮箱时需完成邮箱验证码校验。注册完成后，账号将自动关联到所选专业。
          </div>

          <el-form-item style="width: 100%;">
            <el-button
              :loading="loading"
              :disabled="!registerEnabled"
              size="medium"
              type="primary"
              class="submit-btn"
              @click="handleRegister"
            >
              <span v-if="!loading">注册账号</span>
              <span v-else>注册中...</span>
            </el-button>
            <div class="link-row">
              <router-link class="link-type" :to="'/login'">返回登录</router-link>
            </div>
          </el-form-item>
        </el-form>
      </section>
    </div>

    <div class="el-register-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg, getRegisterDeptOptions, register, sendRegisterEmailCode } from "@/api/login"
import passwordRule from "@/utils/passwordRule"
import defaultSettings from "@/settings"

export default {
  mixins: [passwordRule],
  data() {
    const currentYear = new Date().getFullYear()
    return {
      title: process.env.VUE_APP_TITLE,
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      registerForm: {
        username: "",
        studentNo: "",
        nickName: "",
        academyId: undefined,
        majorId: undefined,
        grade: "",
        phonenumber: "",
        email: "",
        emailCode: "",
        password: "",
        confirmPassword: "",
        code: "",
        uuid: ""
      },
      loading: false,
      captchaEnabled: true,
      registerEnabled: true,
      emailCodeSending: false,
      emailCodeCountdown: 0,
      emailCodeTimer: null,
      academyOptions: [],
      majorOptionsMap: {},
      gradeOptions: Array.from({ length: 8 }, (_, index) => `${currentYear + 1 - index}级`),
      highlights: [
        { value: "学院 / 专业", label: "精确归属" },
        { value: "一步完成", label: "快速注册" },
        { value: "学习空间", label: "立即开启" }
      ],
      registerSteps: [
        { index: "01", title: "填写身份信息", desc: "输入学号、昵称与手机号，完成基础身份录入。" },
        { index: "02", title: "选择学院专业", desc: "按所属学院筛选专业，系统自动建立账号归属。" },
        { index: "03", title: "创建登录密码", desc: "通过验证码确认后即可提交并进入登录。" }
      ]
    }
  },
  computed: {
    registerRules() {
      const rules = {
        username: [
          { required: true, trigger: "blur", message: "请输入登录账号" },
          { min: 2, max: 20, trigger: "blur", message: "账号长度必须在 2 到 20 个字符之间" }
        ],
        studentNo: [
          { required: true, trigger: "blur", message: "请输入学号" },
          { min: 2, max: 20, trigger: "blur", message: "学号长度不能超过 20 个字符" }
        ],
        nickName: [
          { required: true, trigger: "blur", message: "请输入昵称" },
          { min: 2, max: 30, trigger: "blur", message: "昵称长度不能超过 30 个字符" }
        ],
        academyId: [
          { required: true, trigger: "change", message: "请选择学院" }
        ],
        majorId: [
          { required: true, trigger: "change", message: "请选择专业" }
        ],
        grade: [
          { required: true, trigger: "change", message: "请选择年级" },
          { max: 20, trigger: "blur", message: "年级长度不能超过 20 个字符" }
        ],
        phonenumber: [
          { required: true, trigger: "blur", message: "请输入手机号" },
          { pattern: /^1[3-9]\d{9}$/, trigger: "blur", message: "请输入正确的手机号" }
        ],
        email: [
          { type: "email", trigger: "blur", message: "Please enter a valid email" }
        ],
        emailCode: [],
        confirmPassword: [
          { required: true, trigger: "blur", message: "请再次输入密码" },
          {
            validator: (rule, value, callback) => {
              if (this.registerForm.password !== value) {
                callback(new Error("两次输入的密码不一致"))
              } else {
                callback()
              }
            },
            trigger: "blur"
          }
        ]
      }
      if (this.captchaEnabled) {
        rules.code = [{ required: true, trigger: "change", message: "请输入验证码" }]
      }
      return rules
    },
    majorOptions() {
      return this.majorOptionsMap[this.registerForm.academyId] || []
    },
    emailCodeButtonText() {
      return this.emailCodeCountdown > 0 ? `${this.emailCodeCountdown}s` : "Get Code"
    }
  },
  beforeDestroy() {
    if (this.emailCodeTimer) {
      clearInterval(this.emailCodeTimer)
    }
  },
  created() {
    this.getCode()
    this.loadRegisterDeptOptions()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        this.registerEnabled = res.registerEnabled === undefined ? true : res.registerEnabled
        this.pwdChrType = res.pwdChrtype || this.pwdChrType
        this.pwdMinLength = Number(res.pwdMinLength || this.pwdMinLength)
        this.pwdMaxLength = Number(res.pwdMaxLength || this.pwdMaxLength)
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.registerForm.uuid = res.uuid
        }
      }).catch(() => {})
    },
    loadRegisterDeptOptions() {
      getRegisterDeptOptions().then(res => {
        const academyOptions = (res.data || []).map(item => ({
          id: item.id,
          label: item.label,
          children: item.children || []
        }))
        this.academyOptions = academyOptions
        this.majorOptionsMap = academyOptions.reduce((acc, item) => {
          acc[item.id] = item.children.map(child => ({
            id: child.id,
            label: child.label
          }))
          return acc
        }, {})
      }).catch(() => {
        this.$modal.msgError("学院专业选项加载失败，请稍后重试")
      })
    },
    handleSendEmailCode() {
      if (!this.registerEnabled) {
        this.$modal.msgWarning("Registration is closed")
        return
      }
      if (!this.registerForm.email) {
        this.$modal.msgWarning("Please enter email first")
        return
      }
      this.emailCodeSending = true
      sendRegisterEmailCode({ email: this.registerForm.email }).then(() => {
        this.$modal.msgSuccess("Email code sent")
        this.startEmailCodeCountdown()
      }).finally(() => {
        this.emailCodeSending = false
      })
    },
    startEmailCodeCountdown() {
      this.emailCodeCountdown = 60
      if (this.emailCodeTimer) {
        clearInterval(this.emailCodeTimer)
      }
      this.emailCodeTimer = setInterval(() => {
        this.emailCodeCountdown -= 1
        if (this.emailCodeCountdown <= 0) {
          clearInterval(this.emailCodeTimer)
          this.emailCodeTimer = null
        }
      }, 1000)
    },
    handleAcademyChange() {
      this.registerForm.majorId = undefined
    },
    handleStudentNoBlur() {
      if (!this.registerForm.username && this.registerForm.studentNo) {
        this.registerForm.username = this.registerForm.studentNo
      }
    },
    handleRegister() {
      if (!this.registerEnabled) {
        this.$modal.msgWarning("当前未开放学生自主注册")
        return
      }
      this.handleStudentNoBlur()
      this.$refs.registerForm.validate(valid => {
        if (!valid) {
          return
        }
        if (this.registerForm.email && !this.registerForm.emailCode) {
          this.$modal.msgWarning("Please enter email code")
          return
        }
        this.loading = true
        register(this.registerForm)
          .then(res => {
            const message = (res && res.msg) || (`账号 ${this.registerForm.username} 注册成功`)
            this.$alert(message, "注册成功", {
              confirmButtonText: "去登录",
              type: "success"
            }).then(() => {
              this.$router.push("/login")
            }).catch(() => {})
          })
          .catch(error => {
            const message = (error && error.message) ? error.message : "注册失败，请检查输入后重试"
            this.$modal.msgError(message)
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
          .finally(() => {
            this.loading = false
          })
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.register-page {
  position: relative;
  min-height: 100%;
  padding: 28px 24px 72px;
  overflow: hidden;
  background:
    radial-gradient(circle at top left, rgba(255, 196, 114, 0.22), transparent 34%),
    radial-gradient(circle at bottom right, rgba(68, 122, 255, 0.24), transparent 32%),
    linear-gradient(135deg, rgba(7, 18, 40, 0.92), rgba(16, 44, 83, 0.88)),
    url("../assets/images/login-background.jpg");
  background-size: cover;
  background-position: center;
}

.register-shell {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(320px, 1.05fr) minmax(360px, 0.95fr);
  gap: 0;
  max-width: 1180px;
  min-height: calc(100vh - 120px);
  margin: 0 auto;
  border: 1px solid rgba(255, 255, 255, 0.14);
  border-radius: 32px;
  overflow: hidden;
  box-shadow: 0 32px 90px rgba(3, 10, 24, 0.38);
  backdrop-filter: blur(14px);
}

.register-story {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 52px 48px 40px;
  background:
    linear-gradient(180deg, rgba(244, 185, 93, 0.16), rgba(255, 255, 255, 0.02)),
    linear-gradient(135deg, rgba(10, 23, 52, 0.84), rgba(8, 20, 42, 0.72));
  color: #f7f3ea;
}

.story-top {
  position: relative;
  z-index: 1;
  max-width: 460px;
}

.story-kicker {
  margin: 0 0 14px;
  color: rgba(255, 214, 152, 0.92);
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.story-title {
  margin: 0;
  font-size: clamp(34px, 4vw, 54px);
  line-height: 1.06;
  font-weight: 700;
  letter-spacing: -0.03em;
}

.story-copy {
  margin: 18px 0 0;
  max-width: 420px;
  color: rgba(241, 244, 252, 0.8);
  font-size: 15px;
  line-height: 1.75;
}

.story-orbit {
  position: absolute;
  border-radius: 999px;
  filter: blur(2px);
  opacity: 0.75;
}

.story-orbit-a {
  top: 72px;
  right: 56px;
  width: 180px;
  height: 180px;
  border: 1px solid rgba(255, 213, 145, 0.28);
  box-shadow: inset 0 0 0 18px rgba(255, 213, 145, 0.04);
}

.story-orbit-b {
  top: 122px;
  right: 104px;
  width: 76px;
  height: 76px;
  background: radial-gradient(circle, rgba(255, 206, 123, 0.55), rgba(255, 206, 123, 0.06));
}

.story-panel {
  position: relative;
  z-index: 1;
  margin-top: 36px;
  padding-top: 28px;
  border-top: 1px solid rgba(255, 255, 255, 0.12);
}

.story-panel__label {
  margin-bottom: 16px;
  color: rgba(255, 255, 255, 0.58);
  font-size: 12px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.story-step {
  display: grid;
  grid-template-columns: 48px 1fr;
  gap: 16px;
  align-items: start;
  padding: 14px 0;
}

.story-step + .story-step {
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.story-step__index {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.08);
  color: #ffd596;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.story-step__title {
  color: #ffffff;
  font-size: 16px;
  font-weight: 600;
}

.story-step__desc {
  margin-top: 6px;
  color: rgba(241, 244, 252, 0.72);
  font-size: 13px;
  line-height: 1.7;
}

.story-highlights {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  margin-top: 36px;
}

.highlight-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 18px 16px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(8px);
}

.highlight-item__value {
  color: #fff4de;
  font-size: 18px;
  font-weight: 700;
}

.highlight-item__label {
  color: rgba(241, 244, 252, 0.7);
  font-size: 12px;
  letter-spacing: 0.08em;
}

.register-panel {
  padding: 40px 36px 30px;
  background: rgba(250, 248, 243, 0.96);
}

.register-panel__head {
  margin-bottom: 18px;
}

.eyebrow {
  margin: 0 0 8px;
  color: #b66c1d;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.title {
  margin: 0;
  color: #14233d;
  font-size: 30px;
  font-weight: 700;
  letter-spacing: -0.02em;
}

.subtitle {
  margin: 8px 0 0;
  color: #66748b;
  line-height: 1.7;
}

.register-alert {
  margin-bottom: 14px;
  border-radius: 14px;
}

.register-form {
  .el-input__inner,
  .el-select .el-input__inner {
    height: 46px;
    border: 1px solid #d8dee9;
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.9);
    transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
  }

  .el-input__inner:focus,
  .el-select .el-input.is-focus .el-input__inner {
    border-color: #d58d37;
    box-shadow: 0 0 0 4px rgba(213, 141, 55, 0.12);
  }

  .input-icon {
    height: 45px;
    width: 14px;
    margin-left: 2px;
    color: #8d96a7;
  }
}

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0 14px;
}

.captcha-row {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 112px;
  gap: 12px;
  align-items: center;
}

.register-code-img {
  width: 112px;
  height: 46px;
  border-radius: 14px;
  cursor: pointer;
  object-fit: cover;
  box-shadow: 0 12px 24px rgba(20, 35, 61, 0.12);
}

.form-tip {
  margin: 2px 0 16px;
  padding: 14px 16px;
  border-radius: 16px;
  background: linear-gradient(135deg, rgba(213, 141, 55, 0.08), rgba(34, 100, 191, 0.06));
  color: #67758d;
  font-size: 12px;
  line-height: 1.8;
}

.submit-btn {
  width: 100%;
  height: 48px;
  border: none;
  border-radius: 999px;
  background: linear-gradient(135deg, #d4872f, #efb35b);
  box-shadow: 0 16px 30px rgba(212, 135, 47, 0.28);
  font-weight: 700;
  letter-spacing: 0.08em;
}

.submit-btn:hover,
.submit-btn:focus {
  transform: translateY(-1px);
  box-shadow: 0 18px 34px rgba(212, 135, 47, 0.34);
}

.link-row {
  margin-top: 14px;
  text-align: right;
}

.link-row .link-type {
  color: #1c5cb8;
  font-weight: 600;
}

.el-register-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 2;
  height: 42px;
  line-height: 42px;
  text-align: center;
  color: rgba(255, 255, 255, 0.88);
  font-size: 12px;
  letter-spacing: 0.08em;
}

@media (max-width: 1080px) {
  .register-shell {
    grid-template-columns: 1fr;
  }

  .register-story {
    min-height: 420px;
  }
}

@media (max-width: 768px) {
  .register-page {
    padding: 16px 16px 72px;
  }

  .register-shell {
    min-height: auto;
    border-radius: 24px;
  }

  .register-story,
  .register-panel {
    padding: 28px 22px;
  }

  .story-title {
    font-size: 34px;
  }

  .story-highlights,
  .form-grid {
    grid-template-columns: 1fr;
  }

  .captcha-row {
    grid-template-columns: 1fr;
  }

  .register-code-img {
    width: 100%;
    height: 48px;
  }
}
</style>
