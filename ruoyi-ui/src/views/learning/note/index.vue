<template>
  <learning-collection-list
    field="learningNotes"
    title="我的笔记"
    type-label="笔记"
    tag-type="success"
    empty-text="暂无笔记记录"
  />
</template>

<script>
import LearningCollectionList from "../components/LearningCollectionList"

export default {
  name: "LearningNote",
  components: { LearningCollectionList }
}
</script>
