<template>
  <div v-loading="loading" class="app-container discussion-page">
    <section class="discussion-head">
      <div>
        <p>Learning Discussion</p>
        <h2>我的讨论</h2>
        <span>查看你在课程学习页发表过的看法和交流记录。</span>
      </div>
      <el-button icon="el-icon-refresh" round @click="getList">刷新</el-button>
    </section>

    <div v-if="discussionList.length" class="discussion-list">
      <article
        v-for="item in discussionList"
        :key="item.discussionId"
        class="discussion-item"
      >
        <div class="discussion-item__top">
          <el-tag size="mini" type="warning">课程讨论</el-tag>
          <span>{{ parseTime(item.createTime) || "-" }}</span>
        </div>
        <h3>{{ item.courseName || "未命名课程" }}</h3>
        <p>{{ item.content }}</p>
        <div class="discussion-item__actions">
          <el-button
            type="primary"
            plain
            size="mini"
            round
            @click="goCourse(item)"
          >进入课程</el-button>
        </div>
      </article>
    </div>

    <el-empty
      v-else
      description="暂无讨论记录，进入课程学习页发表你的看法吧。"
      :image-size="110"
    />
  </div>
</template>

<script>
import { listMyDiscussions } from "@/api/learning"

export default {
  name: "LearningDiscussion",
  data() {
    return {
      loading: false,
      discussionList: []
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listMyDiscussions().then(res => {
        this.discussionList = res.data || []
      }).finally(() => {
        this.loading = false
      })
    },
    goCourse(item) {
      this.$router.push({ path: "/learning/online", query: { courseId: item.courseId } })
    }
  }
}
</script>

<style lang="scss" scoped>
.discussion-page {
  min-height: calc(100vh - 84px);
  background: #f6f8fb;
}

.discussion-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
  padding: 22px 24px;
  border: 1px solid #e6edf5;
  border-radius: 12px;
  background: #fff;
}

.discussion-head p {
  margin: 0 0 6px;
  color: #2563eb;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1px;
}

.discussion-head h2 {
  margin: 0;
  color: #172033;
  font-size: 24px;
}

.discussion-head span {
  display: block;
  margin-top: 8px;
  color: #6b778c;
}

.discussion-list {
  display: grid;
  gap: 14px;
}

.discussion-item {
  padding: 20px 22px;
  border: 1px solid #e6edf5;
  border-radius: 10px;
  background: #fff;
}

.discussion-item__top {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #8a97aa;
  font-size: 12px;
}

.discussion-item h3 {
  margin: 12px 0 10px;
  color: #172033;
  font-size: 18px;
}

.discussion-item p {
  margin: 0;
  color: #4b5565;
  line-height: 1.8;
  white-space: pre-wrap;
}

.discussion-item__actions {
  margin-top: 14px;
  text-align: right;
}

@media screen and (max-width: 768px) {
  .discussion-head {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>
