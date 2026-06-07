<template>
  <profile-memo
    field="learningHistory"
    title="学习历史"
    type-label="历史"
    tag-type="success"
    empty-text="暂无学习历史"
    description="查看和整理已经完成的课程、练习、考试复盘与项目记录。"
    placeholder="记录已经完成的学习过程、课程章节、练习结果或阶段复盘。"
  />
</template>

<script>
import ProfileMemo from "../components/ProfileMemo"

export default {
  name: "LearningHistory",
  components: { ProfileMemo }
}
</script>
