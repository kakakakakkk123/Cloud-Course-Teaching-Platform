<template>
  <learning-collection-list
    field="wrongQuestions"
    title="我的错题"
    type-label="错题"
    tag-type="danger"
    empty-text="暂无错题记录"
  />
</template>

<script>
import LearningCollectionList from "../components/LearningCollectionList"

export default {
  name: "WrongQuestions",
  components: { LearningCollectionList }
}
</script>
