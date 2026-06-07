<template>
  <div class="auth-page">
    <div class="auth-shell">
      <section class="auth-story">
        <div class="story-top">
          <p class="story-kicker">Course Access</p>
          <h1 class="story-title">回到你的课程空间，继续管理与学习。</h1>
          <p class="story-copy">
            使用统一账号进入课程广场、学习中心和教学管理后台。游客可直接返回首页浏览公开课程内容。
          </p>
        </div>

        <div class="story-orbit story-orbit-a" />
        <div class="story-orbit story-orbit-b" />

        <div class="story-panel">
          <div class="story-panel__label">登录流程</div>
          <div class="story-step">
            <span class="story-step__index">01</span>
            <div>
              <div class="story-step__title">输入账号密码</div>
              <div class="story-step__desc">使用管理员、教师或学生账号进入对应工作区。</div>
            </div>
          </div>
          <div class="story-step">
            <span class="story-step__index">02</span>
            <div>
              <div class="story-step__title">完成验证码校验</div>
              <div class="story-step__desc">通过验证码后，系统会按角色加载课程与后台权限。</div>
            </div>
          </div>
          <div class="story-step">
            <span class="story-step__index">03</span>
            <div>
              <div class="story-step__title">进入目标页面</div>
              <div class="story-step__desc">从首页进入后台时会自动回到后台首页。</div>
            </div>
          </div>
        </div>

        <div class="story-highlights">
          <div class="highlight-item">
            <span class="highlight-item__value">课程首页</span>
            <span class="highlight-item__label">公开浏览</span>
          </div>
          <div class="highlight-item">
            <span class="highlight-item__value">角色权限</span>
            <span class="highlight-item__label">自动加载</span>
          </div>
          <div class="highlight-item">
            <span class="highlight-item__value">后台入口</span>
            <span class="highlight-item__label">登录后进入</span>
          </div>
        </div>
      </section>

      <section class="auth-panel">
        <div class="auth-panel__head">
          <p class="eyebrow">账号登录</p>
          <h3 class="title">{{ title }}</h3>
          <p class="subtitle">登录后即可进入课程学习、教学管理或系统后台。</p>
        </div>

        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="auth-form">
          <el-form-item prop="username">
            <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="账号">
              <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              auto-complete="off"
              placeholder="密码"
              show-password
              @keyup.enter.native="handleLogin"
            >
              <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
            </el-input>
          </el-form-item>
          <el-form-item v-if="captchaEnabled" prop="code">
            <div class="captcha-row">
              <el-input
                v-model="loginForm.code"
                auto-complete="off"
                placeholder="验证码"
                @keyup.enter.native="handleLogin"
              >
                <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
              </el-input>
              <img :src="codeUrl" @click="getCode" class="auth-code-img" />
            </div>
          </el-form-item>

          <el-checkbox v-model="loginForm.rememberMe" class="remember-check">记住账号</el-checkbox>

          <el-form-item style="width: 100%;">
            <el-button :loading="loading" size="medium" type="primary" class="submit-btn" @click.native.prevent="handleLogin">
              <span v-if="!loading">登录</span>
              <span v-else>登录中...</span>
            </el-button>
            <el-button plain size="medium" class="ghost-btn" @click="$router.push('/')">
              返回首页
            </el-button>
            <div class="link-row link-row--split">
              <router-link class="link-type" :to="'/forgot-password'">忘记密码</router-link>
              <router-link v-if="register" class="link-type" :to="'/register'">立即注册</router-link>
            </div>
          </el-form-item>
        </el-form>
      </section>
    </div>

    <div class="auth-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import defaultSettings from '@/settings'
import { DEFAULT_HOME_PATH } from '@/utils/home'

export default {
  name: "Login",
  data() {
    return {
      title: process.env.VUE_APP_TITLE,
      footerContent: defaultSettings.footerContent,
      codeUrl: "",
      loginForm: {
        username: "",
        password: "",
        rememberMe: false,
        code: "",
        uuid: ""
      },
      loginRules: {
        username: [{ required: true, trigger: "blur", message: "请输入账号" }],
        password: [{ required: true, trigger: "blur", message: "请输入密码" }],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true,
      register: true,
      redirect: undefined
    }
  },
  watch: {
    $route: {
      handler(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  created() {
    this.getCode()
    this.getCookie()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled
        this.register = res.registerEnabled === undefined ? true : res.registerEnabled
        this.loginRules.code = this.captchaEnabled ? [{ required: true, trigger: "change", message: "请输入验证码" }] : []
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img
          this.loginForm.uuid = res.uuid
        }
      }).catch(() => {
        this.$modal.msgError("验证码加载失败，请稍后重试")
      })
    },
    getCookie() {
      const username = Cookies.get("username")
      const rememberMe = Cookies.get('rememberMe')
      Cookies.remove("password")
      this.loginForm = Object.assign({}, this.loginForm, {
        username: username === undefined ? this.loginForm.username : username,
        password: "",
        rememberMe: rememberMe === 'true'
      })
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 })
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 })
          } else {
            Cookies.remove("username")
            Cookies.remove('rememberMe')
          }
          Cookies.remove("password")
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: this.redirect || DEFAULT_HOME_PATH }).catch(() => {})
          }).catch(() => {
            this.loading = false
            if (this.captchaEnabled) {
              this.getCode()
            }
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import "../assets/styles/auth-page.scss";
</style>
