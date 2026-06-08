<template>
  <div class="portal-entry">
    <i class="el-icon-loading portal-entry__icon"></i>
    <p class="portal-entry__text">正在进入平台...</p>
  </div>
</template>

<script>
import { mapGetters } from "vuex"

export default {
  name: "PortalEntry",
  computed: {
    ...mapGetters(["roles"]),
    isStudent() {
      return this.roles.includes("student")
    },
    isTeacherOrAdmin() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    }
  },
  created() {
    this.redirectToPortalTarget()
  },
  methods: {
    redirectToPortalTarget() {
      if (this.isTeacherOrAdmin) {
        this.$router.replace("/index")
        return
      }
      if (this.isStudent) {
        this.$router.replace("/learning/my-course")
        return
      }
      this.$router.replace("/course-square")
    }
  }
}
</script>

<style scoped>
.portal-entry {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  background: linear-gradient(180deg, #f8fbff 0%, #eef5ff 100%);
  color: #1e3a8a;
}

.portal-entry__icon {
  font-size: 28px;
}

.portal-entry__text {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
}
</style>
