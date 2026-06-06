<template>
  <div v-loading="loading" class="app-container learning-collection">
    <div class="collection-header">
      <div>
        <h2>{{ title }}</h2>
        <div class="collection-meta">
          <span>{{ items.length }} 条记录</span>
          <span v-if="courseCount">{{ courseCount }} 门课程</span>
        </div>
      </div>
      <el-input
        v-model.trim="keyword"
        class="collection-search"
        size="small"
        clearable
        prefix-icon="el-icon-search"
        placeholder="搜索课程、标题或内容"
      />
    </div>

    <div v-if="filteredItems.length" class="collection-list">
      <button
        v-for="item in filteredItems"
        :key="item.id"
        class="collection-item"
        type="button"
        @click="openDetail(item)"
      >
        <div class="collection-item__top">
          <el-tag size="mini" :type="tagType">{{ typeLabel }}</el-tag>
          <span>{{ item.collectedAt || item.updatedAt || "未记录时间" }}</span>
        </div>
        <h3>{{ item.title }}</h3>
        <div class="collection-item__course">
          <i class="el-icon-reading"></i>
          <span>{{ item.courseName || "未关联课程" }}</span>
        </div>
        <p>{{ item.summary || item.detail || item.note || item.content || "暂无摘要" }}</p>
        <div class="collection-item__tags">
          <span v-if="item.chapterTitle">{{ item.chapterTitle }}</span>
          <span v-if="item.contentTitle">{{ item.contentTitle }}</span>
          <span v-for="tag in item.tags" :key="tag">{{ tag }}</span>
        </div>
      </button>
    </div>

    <el-empty v-else :description="emptyText" />

    <el-dialog
      :title="activeItem ? activeItem.title : title"
      :visible.sync="detailOpen"
      width="720px"
      append-to-body
    >
      <div v-if="activeItem" class="collection-detail">
        <div class="detail-meta">
          <el-tag size="mini" :type="tagType">{{ typeLabel }}</el-tag>
          <span>{{ activeItem.courseName || "未关联课程" }}</span>
          <span v-if="activeItem.chapterTitle">{{ activeItem.chapterTitle }}</span>
          <span v-if="activeItem.collectedAt">{{ activeItem.collectedAt }}</span>
        </div>

        <section v-if="activeItem.contentTitle">
          <h4>课程内容</h4>
          <p>{{ activeItem.contentTitle }}</p>
        </section>
        <section v-if="activeItem.questionStem">
          <h4>题干</h4>
          <p>{{ activeItem.questionStem }}</p>
        </section>
        <section v-if="activeItem.myAnswer || activeItem.correctAnswer">
          <h4>答案</h4>
          <p v-if="activeItem.myAnswer">我的答案：{{ activeItem.myAnswer }}</p>
          <p v-if="activeItem.correctAnswer">正确答案：{{ activeItem.correctAnswer }}</p>
        </section>
        <section v-if="activeItem.analysis">
          <h4>解析</h4>
          <p>{{ activeItem.analysis }}</p>
        </section>
        <section v-if="activeItem.note">
          <h4>笔记</h4>
          <p>{{ activeItem.note }}</p>
        </section>
        <section v-if="activeItem.detail || activeItem.content">
          <h4>详情</h4>
          <p>{{ activeItem.detail || activeItem.content }}</p>
        </section>
        <section v-if="activeItem.resourceUrl">
          <h4>资源地址</h4>
          <el-link :href="activeItem.resourceUrl" target="_blank" type="primary">{{ activeItem.resourceUrl }}</el-link>
        </section>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getStudentProfile } from "@/api/system/user"

export default {
  name: "LearningCollectionList",
  props: {
    field: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    typeLabel: {
      type: String,
      required: true
    },
    tagType: {
      type: String,
      default: "primary"
    },
    emptyText: {
      type: String,
      default: "暂无记录"
    }
  },
  data() {
    return {
      loading: false,
      keyword: "",
      items: [],
      activeItem: null,
      detailOpen: false
    }
  },
  computed: {
    filteredItems() {
      const keyword = this.keyword.toLowerCase()
      if (!keyword) {
        return this.items
      }
      return this.items.filter(item => {
        return [
          item.title,
          item.courseName,
          item.chapterTitle,
          item.contentTitle,
          item.summary,
          item.detail,
          item.note,
          item.content,
          item.questionStem
        ].some(value => String(value || "").toLowerCase().includes(keyword))
      })
    },
    courseCount() {
      return new Set(this.items.map(item => item.courseName).filter(Boolean)).size
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.loading = true
      getStudentProfile().then(res => {
        const profile = res.data || {}
        this.items = this.parseItems(profile[this.field])
      }).finally(() => {
        this.loading = false
      })
    },
    parseItems(raw) {
      if (!raw) {
        return []
      }
      if (Array.isArray(raw)) {
        return this.normalizeItems(raw)
      }
      if (typeof raw === "string") {
        const value = raw.trim()
        if (!value) {
          return []
        }
        try {
          const parsed = JSON.parse(value)
          if (Array.isArray(parsed)) {
            return this.normalizeItems(parsed)
          }
          if (Array.isArray(parsed.items)) {
            return this.normalizeItems(parsed.items)
          }
        } catch (e) {
          return this.normalizeItems([{
            title: "历史记录",
            courseName: "个人记录",
            detail: value,
            summary: value,
            tags: ["历史文本"]
          }])
        }
      }
      return []
    },
    normalizeItems(list) {
      return list.map((item, index) => {
        const tags = Array.isArray(item.tags)
          ? item.tags
          : String(item.tags || "").split(",").map(tag => tag.trim()).filter(Boolean)
        return {
          ...item,
          id: item.id || `${this.field}-${index}`,
          title: item.title || item.questionTitle || item.contentTitle || `第 ${index + 1} 条记录`,
          summary: item.summary || item.reason || item.note || item.content || item.detail || "",
          tags
        }
      })
    },
    openDetail(item) {
      this.activeItem = item
      this.detailOpen = true
    }
  }
}
</script>

<style lang="scss" scoped>
.learning-collection {
  color: #1f2937;
}

.collection-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 18px 20px;
  margin-bottom: 16px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
}

.collection-header h2 {
  margin: 0;
  font-size: 20px;
  line-height: 1.35;
}

.collection-meta {
  display: flex;
  gap: 12px;
  margin-top: 8px;
  color: #6b7280;
  font-size: 13px;
}

.collection-search {
  width: 280px;
}

.collection-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 14px;
}

.collection-item {
  display: flex;
  flex-direction: column;
  min-height: 210px;
  padding: 16px;
  text-align: left;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.collection-item:hover {
  border-color: #409eff;
  box-shadow: 0 8px 18px rgba(31, 41, 55, 0.08);
}

.collection-item__top,
.collection-item__course,
.collection-item__tags,
.detail-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

.collection-item__top {
  justify-content: space-between;
  color: #9ca3af;
  font-size: 12px;
}

.collection-item h3 {
  margin: 14px 0 10px;
  font-size: 16px;
  line-height: 1.4;
  color: #111827;
}

.collection-item__course {
  color: #4b5563;
  font-size: 13px;
}

.collection-item p {
  flex: 1;
  margin: 12px 0;
  color: #6b7280;
  font-size: 13px;
  line-height: 1.7;
}

.collection-item__tags {
  flex-wrap: wrap;
}

.collection-item__tags span {
  max-width: 100%;
  padding: 3px 8px;
  color: #475569;
  font-size: 12px;
  background: #f1f5f9;
  border-radius: 4px;
}

.detail-meta {
  flex-wrap: wrap;
  margin-bottom: 18px;
  color: #6b7280;
}

.collection-detail section {
  padding: 14px 0;
  border-top: 1px solid #edf2f7;
}

.collection-detail h4 {
  margin: 0 0 8px;
  font-size: 14px;
  color: #111827;
}

.collection-detail p {
  margin: 0;
  color: #374151;
  line-height: 1.8;
  white-space: pre-wrap;
}

@media (max-width: 768px) {
  .collection-header {
    flex-direction: column;
  }

  .collection-search {
    width: 100%;
  }

  .collection-list {
    grid-template-columns: 1fr;
  }
}
</style>
