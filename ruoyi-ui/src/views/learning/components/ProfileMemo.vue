<template>
  <div v-loading="loading" class="app-container learning-memo">
    <el-card shadow="never" class="memo-card">
      <div slot="header" class="memo-header">
        <div>
          <div class="memo-title">{{ title }}</div>
          <div class="memo-desc">{{ description }}</div>
        </div>
        <div class="memo-actions">
          <el-input
            v-model.trim="keyword"
            class="memo-search"
            size="mini"
            clearable
            prefix-icon="el-icon-search"
            placeholder="搜索内容"
          />
          <el-button type="primary" size="mini" @click="submit">保存内容</el-button>
        </div>
      </div>

      <div v-if="listItems.length" class="memo-list">
        <button
          v-for="item in filteredItems"
          :key="item.id"
          class="memo-item"
          type="button"
          @click="selectItem(item)"
        >
          <div class="memo-item__top">
            <el-tag size="mini" :type="tagType">{{ typeLabel }}</el-tag>
            <span>{{ item.time || item.updatedAt || item.createdAt || "未记录时间" }}</span>
          </div>
          <h3>{{ item.title }}</h3>
          <p>{{ item.summary || item.content || item.detail || item.text || "暂无摘要" }}</p>
        </button>
      </div>

      <el-alert
        v-else-if="!rawValue"
        :title="emptyText"
        type="info"
        :closable="false"
        show-icon
      />

      <el-input
        v-model="rawValue"
        class="memo-editor"
        type="textarea"
        :rows="rows"
        :placeholder="placeholder"
      />
    </el-card>

    <el-dialog
      :title="activeItem ? activeItem.title : title"
      :visible.sync="detailOpen"
      width="680px"
      append-to-body
    >
      <div v-if="activeItem" class="memo-detail">
        <div class="memo-detail__meta">
          <el-tag size="mini" :type="tagType">{{ typeLabel }}</el-tag>
          <span v-if="activeItem.time">{{ activeItem.time }}</span>
          <span v-if="activeItem.courseName">{{ activeItem.courseName }}</span>
        </div>
        <p>{{ activeItem.detail || activeItem.content || activeItem.text || activeItem.summary }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getStudentProfile, updateStudentProfile } from "@/api/system/user"

export default {
  name: "ProfileMemo",
  props: {
    field: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      default: ""
    },
    typeLabel: {
      type: String,
      default: "档案"
    },
    tagType: {
      type: String,
      default: "primary"
    },
    emptyText: {
      type: String,
      default: "暂无记录"
    },
    placeholder: {
      type: String,
      default: "请输入内容"
    },
    rows: {
      type: Number,
      default: 12
    }
  },
  data() {
    return {
      loading: false,
      keyword: "",
      form: {},
      rawValue: "",
      listItems: [],
      activeItem: null,
      detailOpen: false
    }
  },
  computed: {
    filteredItems() {
      const keyword = this.keyword.toLowerCase()
      if (!keyword) {
        return this.listItems
      }
      return this.listItems.filter(item => {
        return [
          item.title,
          item.summary,
          item.content,
          item.detail,
          item.text,
          item.courseName
        ].some(value => String(value || "").toLowerCase().includes(keyword))
      })
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      this.loading = true
      getStudentProfile().then(res => {
        this.form = res.data || {}
        this.rawValue = this.form[this.field] || ""
        this.listItems = this.parseItems(this.rawValue)
      }).finally(() => {
        this.loading = false
      })
    },
    parseItems(raw) {
      if (!raw || typeof raw !== "string") {
        return []
      }
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
        return []
      }
      return []
    },
    normalizeItems(list) {
      return list.map((item, index) => {
        if (typeof item === "string") {
          return {
            id: `${this.field}-${index}`,
            title: `第 ${index + 1} 条记录`,
            text: item
          }
        }
        return {
          ...item,
          id: item.id || `${this.field}-${index}`,
          title: item.title || item.name || item.contentTitle || `第 ${index + 1} 条记录`,
          summary: item.summary || item.content || item.detail || item.text || "",
          time: item.time || item.finishedAt || item.createdAt || item.updatedAt || item.collectedAt || ""
        }
      })
    },
    selectItem(item) {
      this.activeItem = item
      this.detailOpen = true
    },
    submit() {
      this.form[this.field] = this.rawValue
      updateStudentProfile(this.form).then(() => {
        this.listItems = this.parseItems(this.rawValue)
        this.$modal.msgSuccess("保存成功")
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.memo-header,
.memo-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.memo-actions {
  gap: 10px;
}

.memo-search {
  width: 220px;
}

.memo-title {
  font-size: 18px;
  font-weight: 700;
  color: #0f172a;
}

.memo-desc {
  margin-top: 6px;
  color: #64748b;
  font-size: 13px;
}

.memo-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 12px;
  margin-bottom: 16px;
}

.memo-item {
  min-height: 150px;
  padding: 14px;
  text-align: left;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  cursor: pointer;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.memo-item:hover {
  border-color: #409eff;
  box-shadow: 0 8px 18px rgba(31, 41, 55, 0.08);
}

.memo-item__top,
.memo-detail__meta {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #94a3b8;
  font-size: 12px;
}

.memo-item h3 {
  margin: 12px 0 8px;
  color: #111827;
  font-size: 16px;
  line-height: 1.4;
}

.memo-item p,
.memo-detail p {
  margin: 0;
  color: #4b5563;
  line-height: 1.8;
  white-space: pre-wrap;
}

.memo-editor {
  margin-top: 16px;
}

.memo-detail__meta {
  margin-bottom: 14px;
}

@media (max-width: 768px) {
  .memo-header,
  .memo-actions {
    align-items: stretch;
    flex-direction: column;
  }

  .memo-search {
    width: 100%;
  }
}
</style>
