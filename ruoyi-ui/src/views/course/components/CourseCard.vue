<template>
  <el-card class="portal-course-card" shadow="hover" @click.native="handleOpen">
    <div class="portal-course-card__cover">
      <img v-if="coverUrl" :src="coverUrl" :alt="course.courseName">
      <div v-else class="portal-course-card__fallback">
        <span>{{ shortName }}</span>
      </div>
      <span class="portal-course-card__badge">{{ difficultyText }}</span>
      <span v-if="isNewCourse" class="portal-course-card__new">新</span>
    </div>
    <div class="portal-course-card__body">
      <div class="portal-course-card__meta">
        <span class="portal-course-card__category">{{ course.categoryName || "未分类" }}</span>
        <span class="portal-course-card__teacher">{{ course.teacherName || "未设置教师" }}</span>
      </div>
      <h3 class="portal-course-card__title">{{ course.courseName }}</h3>
      <p class="portal-course-card__desc">{{ course.courseSubtitle || course.intro || "暂无课程简介" }}</p>
      <div class="portal-course-card__stats">
        <span>注册 {{ course.enrollCount || 0 }}</span>
        <span>点赞 {{ course.likeCount || 0 }}</span>
        <span>浏览 {{ course.viewCount || 0 }}</span>
      </div>
    </div>
  </el-card>
</template>

<script>
export default {
  name: "CourseCard",
  props: {
    course: {
      type: Object,
      required: true
    },
    changedCourseIds: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    /** 课程封面完整地址 */
    coverUrl() {
      const cover = this.course.coverImage
      if (!cover) {
        return ""
      }
      if (/^https?:\/\//.test(cover)) {
        return cover
      }
      return process.env.VUE_APP_BASE_API + cover
    },
    /** 课程难度文案 */
    difficultyText() {
      const map = {
        "1": "入门",
        "2": "进阶",
        "3": "高级"
      }
      return map[this.course.difficultyLevel] || "综合"
    },
    /** 封面缺失时显示课程简称 */
    shortName() {
      return (this.course.courseName || "课程").slice(0, 2)
    },
    /** 当前课程是否为新增内容 */
    isNewCourse() {
      return this.changedCourseIds.includes(this.course.courseId)
    }
  },
  methods: {
    /** 跳转到课程详情页 */
    handleOpen() {
      this.$router.push(`/course/${this.course.courseId}`)
    }
  }
}
</script>

<style lang="scss" scoped>
.portal-course-card {
  overflow: hidden;
  border-radius: 18px;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.portal-course-card:hover {
  transform: translateY(-3px);
}

.portal-course-card__cover {
  position: relative;
  height: 180px;
  overflow: hidden;
  border-radius: 14px;
  background: linear-gradient(135deg, #dbeafe 0%, #ecfeff 100%);
}

.portal-course-card__cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.portal-course-card__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  color: #1d4ed8;
  font-size: 38px;
  font-weight: 700;
}

.portal-course-card__badge {
  position: absolute;
  top: 12px;
  left: 12px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.76);
  color: #fff;
  font-size: 12px;
}

.portal-course-card__new {
  position: absolute;
  top: 12px;
  right: 12px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 32px;
  height: 20px;
  padding: 0 8px;
  border-radius: 999px;
  background: linear-gradient(135deg, #ff7a45, #ff4d4f);
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  box-shadow: 0 6px 14px rgba(255, 77, 79, 0.25);
}

.portal-course-card__body {
  padding-top: 10px;
}

.portal-course-card__meta,
.portal-course-card__stats {
  display: flex;
  justify-content: space-between;
  gap: 10px;
  color: #64748b;
  font-size: 13px;
}

.portal-course-card__category {
  color: #1d4ed8;
  font-weight: 700;
}

.portal-course-card__title {
  margin: 12px 0 8px;
  color: #0f172a;
  font-size: 18px;
}

.portal-course-card__desc {
  min-height: 48px;
  margin: 0 0 12px;
  color: #475569;
  line-height: 1.7;
}
</style>
