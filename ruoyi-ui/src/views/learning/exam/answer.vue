<template>
  <div class="app-container">
    <el-empty description="正在打开考试页面..." />
  </div>
</template>

<script>
export default {
  name: "StudentExamAnswerRedirect",
  created() {
    const recordId = this.$route.params.recordId
    this.$router.replace(recordId ? `/learning/exam/take/${recordId}` : "/learning/exam")
  }
}
</script>
