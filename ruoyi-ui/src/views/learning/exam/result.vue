<template>
  <div class="app-container">
    <el-empty description="正在返回考试列表..." />
  </div>
</template>

<script>
export default {
  name: "StudentExamResultRedirect",
  created() {
    this.$router.replace("/learning/exam")
  }
}
</script>
