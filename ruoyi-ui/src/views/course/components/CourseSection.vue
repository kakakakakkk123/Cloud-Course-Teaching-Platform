<template>
  <section class="portal-section">
    <div class="portal-section__head">
      <div>
        <p class="portal-section__kicker">{{ kicker }}</p>
        <h2>{{ title }}</h2>
      </div>
      <button v-if="showMore" type="button" class="portal-section__more" @click="$router.push('/course-square')">
        查看更多
      </button>
    </div>
    <div v-if="courses && courses.length" class="portal-section__grid">
      <course-card
        v-for="item in courses"
        :key="item.courseId"
        :course="item"
        :changed-course-ids="changedCourseIds"
      />
    </div>
    <el-empty v-else description="暂无课程内容" :image-size="96" />
  </section>
</template>

<script>
import CourseCard from "./CourseCard"

export default {
  name: "CourseSection",
  components: { CourseCard },
  props: {
    title: {
      type: String,
      required: true
    },
    kicker: {
      type: String,
      default: ""
    },
    courses: {
      type: Array,
      default: () => []
    },
    changedCourseIds: {
      type: Array,
      default: () => []
    },
    showMore: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style lang="scss" scoped>
.portal-section {
  margin-top: 34px;
}

.portal-section__head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.portal-section__head h2 {
  margin: 6px 0 0;
  color: #0f172a;
  font-size: 28px;
  text-wrap: balance;
}

.portal-section__kicker {
  margin: 0;
  color: #2563eb;
  letter-spacing: 2px;
  font-size: 12px;
  font-weight: 700;
}

.portal-section__grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 18px;
}

.portal-section__more {
  min-height: 40px;
  padding: 0 14px;
  border: 1px solid rgba(191, 219, 254, 0.92);
  border-radius: 999px;
  background: #eff6ff;
  color: #1d4ed8;
  cursor: pointer;
  font-size: 13px;
  font-weight: 600;
  transition: background-color 0.2s ease, border-color 0.2s ease, transform 0.2s ease;
}

.portal-section__more:hover,
.portal-section__more:focus-visible {
  background: #dbeafe;
  border-color: rgba(96, 165, 250, 0.92);
  outline: none;
}

.portal-section__more:hover {
  transform: translateY(-1px);
}
</style>
