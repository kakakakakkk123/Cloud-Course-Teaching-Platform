<template>
  <profile-memo
    field="discussions"
    title="我的讨论"
    type-label="讨论"
    tag-type="warning"
    empty-text="暂无讨论记录"
    description="沉淀课堂问答、小组协作、课程评论和学习交流中的关键结论。"
    placeholder="记录讨论主题、参与人、结论和后续行动。"
  />
</template>

<script>
import ProfileMemo from "../components/ProfileMemo"

export default {
  name: "LearningDiscussion",
  components: { ProfileMemo }
}
</script>
