<template>
  <div class="security-panel">
    <div class="security-panel__intro">
      <h3>账号安全</h3>
      <p>{{ subtitle }}</p>
    </div>

    <el-form ref="form" :model="user" :rules="formRules" label-width="96px" class="security-form">
      <el-form-item label="当前密码" prop="oldPassword">
        <el-input v-model="user.oldPassword" placeholder="请输入当前密码" type="password" show-password />
      </el-form-item>

      <el-form-item label="新密码" prop="newPassword" :rules="infoPwdValidator">
        <el-input v-model="user.newPassword" placeholder="请输入新密码" type="password" show-password />
      </el-form-item>

      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input v-model="user.confirmPassword" placeholder="请再次输入新密码" type="password" show-password />
      </el-form-item>

      <div class="security-actions">
        <el-button type="primary" @click="submit">更新密码</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
import { updateUserPwd } from "@/api/system/user"
import passwordRule from "@/utils/passwordRule"

export default {
  mixins: [passwordRule],
  props: {
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
      user: {
        oldPassword: undefined,
        newPassword: undefined,
        confirmPassword: undefined
      }
    }
  },
  computed: {
    subtitle() {
      if (this.roleText.includes("管理员")) {
        return "定期更新密码可以更好地保护后台管理权限、个人资料与系统操作安全。"
      }
      if (!this.isStudent) {
        return "定期更新密码可以更好地保护教学资料、个人信息与平台账号安全。"
      }
      return "定期更新密码可以更好地保护课程记录、个人资料和学习记录安全。"
    },
    formRules() {
      return {
        oldPassword: [
          { required: true, message: "请输入当前密码", trigger: "blur" }
        ],
        confirmPassword: [
          { required: true, message: "请确认新密码", trigger: "blur" },
          {
            validator: (rule, value, callback) => {
              if (this.user.newPassword !== value) {
                callback(new Error("两次输入的密码不一致"))
              } else {
                callback()
              }
            },
            trigger: "blur"
          }
        ]
      }
    }
  },
  methods: {
    submit() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        updateUserPwd(this.user.oldPassword, this.user.newPassword).then(() => {
          this.$modal.msgSuccess("密码已更新")
          this.user.oldPassword = undefined
          this.user.newPassword = undefined
          this.user.confirmPassword = undefined
        })
      })
    }
  }
}
</script>

<style scoped lang="scss">
.security-panel__intro {
  margin-bottom: 18px;
}

.security-panel__intro h3 {
  margin: 0;
  color: #173766;
  font-size: 22px;
}

.security-panel__intro p {
  margin: 8px 0 0;
  color: #73819a;
  line-height: 1.7;
}

.security-form {
  max-width: 720px;
}

.security-form ::v-deep .el-input__inner {
  height: 44px;
  border-radius: 14px;
  border-color: #d9e1ee;
  background: #fbfcfe;
}

.security-actions {
  display: flex;
  gap: 12px;
  margin-top: 12px;
}

@media (max-width: 768px) {
  .security-actions {
    flex-wrap: wrap;
  }
}
</style>
