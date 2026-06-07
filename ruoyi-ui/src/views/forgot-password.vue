<template>
  <div class="auth-page">
    <div class="auth-shell">
      <section class="auth-story">
        <div class="story-top">
          <p class="story-kicker">Account Recovery</p>
          <h1 class="story-title">找回账号访问权，继续你的课程旅程。</h1>
          <p class="story-copy">
            通过登录账号、学号与验证码确认身份后，即可设置新的登录密码。
          </p>
        </div>

        <div class="story-orbit story-orbit-a" />
        <div class="story-orbit story-orbit-b" />

        <div class="story-panel">
          <div class="story-panel__label">找回流程</div>
          <div class="story-step">
            <span class="story-step__index">01</span>
            <div>
              <div class="story-step__title">确认账号身份</div>
              <div class="story-step__desc">输入登录账号和学号，确保重置请求属于本人。</div>
            </div>
          </div>
          <div class="story-step">
            <span class="story-step__index">02</span>
            <div>
              <div class="story-step__title">设置新的密码</div>
              <div class="story-step__desc">使用符合安全规则的新密码，避免与旧密码重复。</div>
            </div>
          </div>
          <div class="story-step">
            <span class="story-step__index">03</span>
            <div>
              <div class="story-step__title">返回登录</div>
              <div class="story-step__desc">重置成功后回到登录页，用新密码继续访问平台。</div>
            </div>
          </div>
        </div>

        <div class="story-highlights">
          <div class="highlight-item">
            <span class="highlight-item__value">身份校验</span>
            <span class="highlight-item__label">账号 + 学号</span>
          </div>
          <div class="highlight-item">
            <span class="highlight-item__value">验证码</span>
            <span class="highlight-item__label">安全确认</span>
          </div>
          <div class="highlight-item">
            <span class="highlight-item__value">新密码</span>
            <span class="highlight-item__label">即时生效</span>
          </div>
        </div>
      </section>

      <section class="auth-panel auth-panel--compact">
        <div class="auth-panel__head">
          <p class="eyebrow">密码找回</p>
          <h3 class="title">找回密码</h3>
          <p class="subtitle">填写账号身份信息后，设置新的登录密码。</p>
        </div>

        <el-form ref="form" :model="form" :rules="rules" class="auth-form">
          <el-form-item prop="username">
            <el-input v-model.trim="form.username" placeholder="登录账号">
              <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item prop="studentNo">
            <el-input v-model.trim="form.studentNo" placeholder="学号">
              <svg-icon slot="prefix" icon-class="number" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item prop="email">
            <el-input v-model.trim="form.email" placeholder="绑定邮箱（可选）">
              <svg-icon slot="prefix" icon-class="email" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item v-if="forgotPasswordEmailRequired || form.email" prop="emailCode">
            <div class="captcha-row">
              <el-input v-model.trim="form.emailCode" placeholder="邮箱验证码">
                <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
              </el-input>
              <el-button :loading="emailCodeSending" :disabled="emailCodeCountdown > 0" @click="handleSendEmailCode">
                {{ emailCodeButtonText }}
              </el-button>
            </div>
          </el-form-item>
          <el-form-item prop="newPassword" :rules="registerPwdValidator">
            <el-input v-model="form.newPassword" type="password" show-password placeholder="新密码">
              <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input v-model="form.confirmPassword" type="password" show-password placeholder="确认密码">
              <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item v-if="captchaEnabled" prop="code">
            <div class="captcha-row">
              <el-input v-model.trim="form.code" placeholder="验证码">
                <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
              </el-input>
              <img :src="codeUrl" @click="getCode" class="auth-code-img" />
            </div>
          </el-form-item>

          <el-button :loading="loading" type="primary" class="submit-btn" @click="handleSubmit">重置密码</el-button>
          <div class="link-row link-row--split">
            <router-link class="link-type" :to="'/'">返回首页</router-link>
            <router-link class="link-type" :to="'/login'">返回登录</router-link>
          </div>
        </el-form>
      </section>
    </div>

    <div class="auth-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg, forgotPassword, sendForgotPasswordEmailCode } from "@/api/login"
import passwordRule from "@/utils/passwordRule"
import defaultSettings from "@/settings"

export default {
  mixins: [passwordRule],
  data() {
    return {
      form: {
        username: "",
        studentNo: "",
        email: "",
        emailCode: "",
        newPassword: "",
        confirmPassword: "",
        code: "",
        uuid: ""
      },
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      captchaEnabled: true,
      forgotPasswordEmailRequired: false,
      emailCodeSending: false,
      emailCodeCountdown: 0,
      emailCodeTimer: null,
      loading: false,
      rules: {
        username: [{ required: true, message: "请输入登录账号", trigger: "blur" }],
        studentNo: [{ required: true, message: "请输入学号", trigger: "blur" }],
        confirmPassword: [{ required: true, message: "请再次输入密码", trigger: "blur" }],
        email: [{ type: "email", message: "Please enter a valid email", trigger: "blur" }],
        emailCode: [],
        code: []
      }
    }
  },
  computed: {
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
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        this.rules.code = this.captchaEnabled ? [{ required: true, trigger: "change", message: "请输入验证码" }] : []
        this.forgotPasswordEmailRequired = !!res.forgotPasswordEmailRequired
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.form.uuid = res.uuid
        }
      }).catch(() => {
        this.$modal.msgError("验证码加载失败，请稍后重试")
      })
    },
    handleSendEmailCode() {
      if (!this.form.username || !this.form.studentNo) {
        this.$modal.msgWarning("Please enter account and student number first")
        return
      }
      this.emailCodeSending = true
      sendForgotPasswordEmailCode({
        username: this.form.username,
        studentNo: this.form.studentNo,
        email: this.form.email
      }).then(() => {
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
    handleSubmit() {
      this.$refs.form.validate(valid => {
        if (!valid) return
        if ((this.forgotPasswordEmailRequired || this.form.email) && !this.form.emailCode) {
          this.$modal.msgWarning("Please enter email code")
          return
        }
        if (this.form.newPassword !== this.form.confirmPassword) {
          this.$modal.msgWarning("两次输入的密码不一致")
          return
        }
        this.loading = true
        forgotPassword(this.form)
          .then(() => {
            this.$modal.msgSuccess("密码重置成功")
            this.$router.push("/login")
          })
          .catch(() => {
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

<style scoped lang="scss">
@import "../assets/styles/auth-page.scss";
</style>
