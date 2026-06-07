<template>
  <div class="app-container">
    <el-empty description="正在打开新版学生账号管理" />
  </div>
</template>

<script>
export default {
  name: "LegacyStudentAccountRedirect",
  created() {
    this.$router.replace("/account/student")
  }
}
</script>
