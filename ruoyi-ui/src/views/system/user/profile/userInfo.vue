<template>
  <div class="profile-form-panel">
    <div class="profile-form-panel__intro">
      <h3>{{ sectionTitle }}</h3>
      <p>{{ sectionSubtitle }}</p>
    </div>

    <el-form ref="form" :model="form" :rules="rules" label-width="90px" class="profile-form">
      <div class="profile-form__grid">
        <el-form-item :label="nameLabel" prop="nickName">
          <el-input v-model="form.nickName" maxlength="30" :placeholder="namePlaceholder" />
        </el-form-item>

        <el-form-item label="手机号" prop="phonenumber">
          <el-input v-model="form.phonenumber" maxlength="11" placeholder="请输入手机号" />
        </el-form-item>

        <el-form-item label="邮箱" prop="email" class="profile-form__item--full">
          <el-input v-model="form.email" maxlength="50" placeholder="请输入常用邮箱" />
        </el-form-item>

        <el-form-item label="个性签名" prop="signature" class="profile-form__item--full">
          <el-input
            v-model="form.signature"
            maxlength="200"
            type="textarea"
            :rows="3"
            :placeholder="signaturePlaceholder"
          />
        </el-form-item>
      </div>

      <el-form-item label="性别">
        <el-radio-group v-model="form.sex">
          <el-radio label="0">男</el-radio>
          <el-radio label="1">女</el-radio>
        </el-radio-group>
      </el-form-item>

      <div class="profile-form__actions">
        <el-button type="primary" @click="submit">保存资料</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
import { getStudentProfile, updateStudentProfile, updateUserProfile } from "@/api/system/user"

export default {
  props: {
    user: {
      type: Object,
      default: () => ({})
    },
    roleText: {
      type: String,
      default: "学生"
    },
    isStudent: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      form: {},
      rules: {
        nickName: [
          { required: true, message: "请输入显示昵称", trigger: "blur" }
        ],
        email: [
          { required: true, message: "请输入邮箱地址", trigger: "blur" },
          {
            type: "email",
            message: "请输入正确的邮箱地址",
            trigger: ["blur", "change"]
          }
        ],
        phonenumber: [
          { required: true, message: "请输入手机号", trigger: "blur" },
          {
            pattern: /^1[3-9][0-9]\d{8}$/,
            message: "请输入正确的手机号",
            trigger: "blur"
          }
        ],
        signature: [
          { max: 200, message: "个性签名不能超过 200 个字符", trigger: "blur" }
        ]
      }
    }
  },
  computed: {
    isAdmin() {
      return this.roleText.includes("管理员")
    },
    sectionTitle() {
      return this.isStudent ? "基础资料" : "个人资料"
    },
    sectionSubtitle() {
      if (this.isAdmin) {
        return "完善管理员联系信息与展示昵称，便于后台协作、通知接收与身份识别。"
      }
      if (!this.isStudent) {
        return "完善教师联系信息与展示昵称，便于教学沟通、协作通知与平台身份识别。"
      }
      return "完善联系信息与展示昵称，便于课程通知、学习互动与平台身份识别。"
    },
    nameLabel() {
      return this.isStudent ? "学生昵称" : "显示昵称"
    },
    namePlaceholder() {
      return this.isStudent ? "请输入昵称" : "请输入显示昵称"
    },
    signaturePlaceholder() {
      if (this.isAdmin) {
        return "一句话介绍你的管理职责或工作关注点"
      }
      if (!this.isStudent) {
        return "一句话介绍你的教学方向或当前负责内容"
      }
      return "一句话介绍你的学习状态或成长目标"
    }
  },
  created() {
    this.loadProfileExtra()
  },
  watch: {
    user: {
      handler(user) {
        this.form = {
          nickName: user.nickName,
          phonenumber: user.phonenumber,
          email: user.email,
          sex: user.sex,
          signature: this.form.signature
        }
      },
      immediate: true
    }
  },
  methods: {
    loadProfileExtra() {
      getStudentProfile().then(res => {
        const profile = res.data || {}
        this.form = {
          ...this.form,
          signature: profile.signature || ""
        }
      })
    },
    submit() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        updateUserProfile(this.form).then(() => {
          updateStudentProfile({ signature: this.form.signature }).then(() => {
            this.$modal.msgSuccess("个人资料已更新")
            this.user.nickName = this.form.nickName
            this.user.phonenumber = this.form.phonenumber
            this.user.email = this.form.email
            this.user.sex = this.form.sex
          })
        })
      })
    }
  }
}
</script>

<style scoped lang="scss">
.profile-form-panel__intro {
  margin-bottom: 18px;
}

.profile-form-panel__intro h3 {
  margin: 0;
  color: #173766;
  font-size: 22px;
}

.profile-form-panel__intro p {
  margin: 8px 0 0;
  color: #73819a;
  line-height: 1.7;
}

.profile-form__grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0 16px;
}

.profile-form__item--full {
  grid-column: 1 / -1;
}

.profile-form ::v-deep .el-input__inner {
  height: 44px;
  border-radius: 14px;
  border-color: #d9e1ee;
  background: #fbfcfe;
}

.profile-form ::v-deep .el-textarea__inner {
  border-radius: 14px;
  border-color: #d9e1ee;
  background: #fbfcfe;
  line-height: 1.7;
}

.profile-form__actions {
  display: flex;
  gap: 12px;
  margin-top: 12px;
}

@media (max-width: 768px) {
  .profile-form__grid {
    grid-template-columns: 1fr;
  }

  .profile-form__item--full {
    grid-column: auto;
  }

  .profile-form__actions {
    flex-wrap: wrap;
  }
}
</style>
