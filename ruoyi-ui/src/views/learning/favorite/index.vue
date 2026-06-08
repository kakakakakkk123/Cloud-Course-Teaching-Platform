<template>
  <learning-collection-list
    field="favorites"
    title="我的收藏"
    type-label="收藏"
    tag-type="warning"
    empty-text="暂无收藏记录"
    :allow-course-favorite-add="true"
  />
</template>

<script>
import LearningCollectionList from "../components/LearningCollectionList"

export default {
  name: "FavoriteCourse",
  components: { LearningCollectionList }
}
</script>
