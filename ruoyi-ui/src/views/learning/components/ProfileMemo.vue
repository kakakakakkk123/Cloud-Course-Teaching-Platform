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
          <el-button
            v-if="allowQuickAdd"
            type="success"
            size="mini"
            icon="el-icon-plus"
            @click="openQuickAdd"
          >{{ quickAddButtonText }}</el-button>
          <el-button v-if="showRawEditor" type="primary" size="mini" @click="submit">保存内容</el-button>
        </div>
      </div>

      <el-form
        v-if="allowQuickAdd && quickAddOpen"
        ref="quickAddForm"
        :model="quickAddForm"
        :rules="quickAddRules"
        class="quick-add"
        label-width="72px"
      >
        <el-form-item label="任务" prop="title">
          <el-input
            v-model.trim="quickAddForm.title"
            maxlength="80"
            show-word-limit
            placeholder="输入一条学习任务"
          />
        </el-form-item>
        <el-form-item label="说明">
          <el-input
            v-model.trim="quickAddForm.content"
            type="textarea"
            :rows="3"
            maxlength="300"
            show-word-limit
            placeholder="补充课程、章节、提交要求等"
          />
        </el-form-item>
        <el-form-item label="日期">
          <el-date-picker
            v-model="quickAddForm.time"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="选择计划完成日期"
          />
        </el-form-item>
        <div class="quick-add__actions">
          <el-button size="mini" @click="quickAddOpen = false">取消</el-button>
          <el-button
            type="primary"
            size="mini"
            :loading="quickAddSaving"
            @click="addQuickItem"
          >添加任务</el-button>
        </div>
      </el-form>

      <div v-if="todoMode" class="todo-stats">
        <div class="todo-stat todo-stat--today">
          <span class="todo-stat__label">今日待完成</span>
          <strong>{{ todoStats.todayPending }}</strong>
        </div>
        <div class="todo-stat todo-stat--done">
          <span class="todo-stat__label">已完成</span>
          <strong>{{ todoStats.done }}</strong>
        </div>
        <div class="todo-stat todo-stat--overdue">
          <span class="todo-stat__label">逾期</span>
          <strong>{{ todoStats.overdue }}</strong>
        </div>
      </div>

      <div v-if="listItems.length" class="memo-list">
        <button
          v-for="item in filteredItems"
          :key="item.id"
          class="memo-item"
          :class="todoMode ? todoItemClass(item) : ''"
          type="button"
          @click="selectItem(item)"
        >
          <div class="memo-item__top">
            <el-tag v-if="todoMode" size="mini" :type="todoStatusTag(item)">{{ todoStatusText(item) }}</el-tag>
            <el-tag v-else size="mini" :type="tagType">{{ typeLabel }}</el-tag>
            <span>{{ todoMode ? todoDueText(item) : (item.time || item.updatedAt || item.createdAt || "未记录时间") }}</span>
            <el-tag v-if="todoMode && isTodoOverdue(item)" size="mini" type="danger" effect="dark">逾期</el-tag>
            <el-tag v-else-if="todoMode && isTodoToday(item)" size="mini" type="warning" effect="dark">当日待办</el-tag>
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
        v-if="showRawEditor"
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
      <el-form
        v-if="todoMode && activeItem"
        ref="todoForm"
        :model="todoForm"
        :rules="todoRules"
        class="memo-detail memo-detail--form"
        label-width="86px"
      >
        <div class="memo-detail__meta todo-detail-meta">
          <el-tag size="mini" :type="todoStatusTag(activeItem)">{{ todoStatusText(activeItem) }}</el-tag>
          <span>{{ todoDueText(activeItem) }}</span>
          <el-tag v-if="isTodoOverdue(activeItem)" size="mini" type="danger" effect="dark">逾期</el-tag>
          <el-tag v-else-if="isTodoToday(activeItem)" size="mini" type="warning" effect="dark">当日待办</el-tag>
        </div>
        <el-form-item label="任务标题" prop="title">
          <el-input
            v-model.trim="todoForm.title"
            maxlength="80"
            show-word-limit
            placeholder="请输入待办标题"
          />
        </el-form-item>
        <el-form-item label="待办内容">
          <el-input
            v-model.trim="todoForm.content"
            type="textarea"
            :rows="5"
            maxlength="500"
            show-word-limit
            placeholder="请输入待办内容"
          />
        </el-form-item>
        <el-form-item label="截止日期">
          <el-date-picker
            v-model="todoForm.dueDate"
            type="date"
            value-format="yyyy-MM-dd"
            placeholder="请选择截止日期"
          />
        </el-form-item>
        <el-form-item label="待办状态" prop="status">
          <el-select v-model="todoForm.status" placeholder="请选择状态">
            <el-option
              v-for="option in todoStatusOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <div v-else-if="activeItem" class="memo-detail">
        <div class="memo-detail__meta">
          <el-tag size="mini" :type="tagType">{{ typeLabel }}</el-tag>
          <span v-if="activeItem.time">{{ activeItem.time }}</span>
          <span v-if="activeItem.courseName">{{ activeItem.courseName }}</span>
        </div>
        <p>{{ activeItem.detail || activeItem.content || activeItem.text || activeItem.summary }}</p>
      </div>
      <div v-if="todoMode && activeItem" slot="footer" class="memo-dialog-footer">
        <el-button type="danger" plain :loading="detailSaving" @click="deleteActiveTodo">删除待办</el-button>
        <div class="memo-dialog-footer__right">
          <el-button @click="detailOpen = false">取消</el-button>
          <el-button type="primary" :loading="detailSaving" @click="saveActiveTodo">保存修改</el-button>
        </div>
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
    },
    allowQuickAdd: {
      type: Boolean,
      default: false
    },
    quickAddButtonText: {
      type: String,
      default: "新增一条"
    },
    showRawEditor: {
      type: Boolean,
      default: true
    },
    todoMode: {
      type: Boolean,
      default: false
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
      detailOpen: false,
      detailSaving: false,
      quickAddOpen: false,
      quickAddSaving: false,
      quickAddForm: {
        title: "",
        content: "",
        time: ""
      },
      quickAddRules: {
        title: [
          { required: true, message: "请输入学习任务", trigger: "blur" }
        ]
      },
      todoForm: {
        title: "",
        content: "",
        dueDate: "",
        status: "todo"
      },
      todoRules: {
        title: [
          { required: true, message: "请输入待办标题", trigger: "blur" }
        ],
        status: [
          { required: true, message: "请选择待办状态", trigger: "change" }
        ]
      },
      todoStatusOptions: [
        { label: "待办", value: "todo" },
        { label: "已完成", value: "done" }
      ]
    }
  },
  computed: {
    displayItems() {
      if (!this.todoMode) {
        return this.listItems
      }
      return this.sortTodoItems(this.listItems)
    },
    filteredItems() {
      const keyword = this.keyword.toLowerCase()
      if (!keyword) {
        return this.displayItems
      }
      return this.displayItems.filter(item => {
        return [
          item.title,
          item.summary,
          item.content,
          item.detail,
          item.text,
          item.courseName
        ].some(value => String(value || "").toLowerCase().includes(keyword))
      })
    },
    todoStats() {
      if (!this.todoMode) {
        return {
          todayPending: 0,
          done: 0,
          overdue: 0
        }
      }
      return this.listItems.reduce((stats, item) => {
        if (this.isTodoDone(item)) {
          stats.done += 1
        } else {
          if (this.isTodoToday(item)) {
            stats.todayPending += 1
          }
          if (this.isTodoOverdue(item)) {
            stats.overdue += 1
          }
        }
        return stats
      }, {
        todayPending: 0,
        done: 0,
        overdue: 0
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
    parseStoredList(raw) {
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
          return parsed
        }
        if (Array.isArray(parsed.items)) {
          return parsed.items
        }
      } catch (e) {
        return [{
          id: `${this.field}-legacy-${Date.now()}`,
          title: "历史记录",
          content: value,
          time: "",
          tags: ["历史文本"]
        }]
      }
      return []
    },
    normalizeItems(list) {
      return list.map((item, index) => {
        if (typeof item === "string") {
          return {
            id: `${this.field}-${index}`,
            title: `第 ${index + 1} 条记录`,
            text: item,
            status: this.todoMode ? "todo" : undefined,
            _rawIndex: index
          }
        }
        const dueDate = item.dueDate || item.deadline || item.time || ""
        return {
          ...item,
          id: item.id || `${this.field}-${index}`,
          title: item.title || item.name || item.contentTitle || `第 ${index + 1} 条记录`,
          summary: item.summary || item.content || item.detail || item.text || "",
          time: this.todoMode ? dueDate : (item.time || item.finishedAt || item.createdAt || item.updatedAt || item.collectedAt || ""),
          dueDate,
          status: item.status || item.state || "todo",
          _rawIndex: index
        }
      })
    },
    selectItem(item) {
      this.activeItem = item
      if (this.todoMode) {
        this.todoForm = {
          title: item.title || "",
          content: item.content || item.detail || item.text || item.summary || "",
          dueDate: this.getTodoDueDate(item),
          status: item.status || "todo"
        }
      }
      this.detailOpen = true
    },
    openQuickAdd() {
      this.quickAddOpen = true
      this.$nextTick(() => {
        if (this.$refs.quickAddForm) {
          this.$refs.quickAddForm.clearValidate()
        }
      })
    },
    resetQuickAddForm() {
      this.quickAddForm = {
        title: "",
        content: "",
        time: ""
      }
      if (this.$refs.quickAddForm) {
        this.$refs.quickAddForm.clearValidate()
      }
    },
    addQuickItem() {
      this.$refs.quickAddForm.validate(valid => {
        if (!valid) {
          return
        }
        const now = new Date()
        const pad = value => String(value).padStart(2, "0")
        const createdAt = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
        const storedItems = this.parseStoredList(this.rawValue)
        const item = {
          id: `todo-${now.getTime()}`,
          title: this.quickAddForm.title,
          content: this.quickAddForm.content,
          time: this.quickAddForm.time,
          dueDate: this.quickAddForm.time,
          status: "todo",
          createdAt,
          updatedAt: createdAt,
          tags: ["自建待办"]
        }
        storedItems.push(item)
        this.quickAddSaving = true
        this.persistStoredItems(storedItems, "添加成功").then(() => {
          this.quickAddOpen = false
          this.resetQuickAddForm()
        }).finally(() => {
          this.quickAddSaving = false
        })
      })
    },
    saveActiveTodo() {
      this.$refs.todoForm.validate(valid => {
        if (!valid) {
          return
        }
        const storedItems = this.parseStoredList(this.rawValue)
        const index = this.findStoredIndex(this.activeItem, storedItems)
        if (index === -1) {
          this.$modal.msgError("未找到待办记录")
          return
        }
        const now = this.formatDateTime(new Date())
        const original = typeof storedItems[index] === "object" && storedItems[index] !== null
          ? storedItems[index]
          : {}
        storedItems.splice(index, 1, {
          ...original,
          id: original.id || this.activeItem.id,
          title: this.todoForm.title,
          content: this.todoForm.content,
          summary: this.todoForm.content,
          time: this.todoForm.dueDate,
          dueDate: this.todoForm.dueDate,
          status: this.todoForm.status,
          updatedAt: now
        })
        this.detailSaving = true
        this.persistStoredItems(storedItems, "修改成功").then(() => {
          const refreshed = this.listItems.find(item => item.id === (original.id || this.activeItem.id))
          this.activeItem = refreshed || null
          this.detailOpen = false
        }).finally(() => {
          this.detailSaving = false
        })
      })
    },
    deleteActiveTodo() {
      this.$modal.confirm("确认删除该待办吗？").then(() => {
        const storedItems = this.parseStoredList(this.rawValue)
        const index = this.findStoredIndex(this.activeItem, storedItems)
        if (index === -1) {
          this.$modal.msgError("未找到待办记录")
          return Promise.reject(new Error("todo not found"))
        }
        storedItems.splice(index, 1)
        this.detailSaving = true
        return this.persistStoredItems(storedItems, "删除成功")
      }).then(() => {
        this.detailOpen = false
        this.activeItem = null
      }).catch(() => {
      }).finally(() => {
        this.detailSaving = false
      })
    },
    persistStoredItems(storedItems, successMessage) {
      this.rawValue = JSON.stringify(storedItems, null, 2)
      this.form[this.field] = this.rawValue
      return updateStudentProfile(this.form).then(() => {
        this.listItems = this.parseItems(this.rawValue)
        this.$modal.msgSuccess(successMessage)
      })
    },
    findStoredIndex(item, storedItems) {
      if (!item) {
        return -1
      }
      const idIndex = storedItems.findIndex(storedItem => {
        return storedItem && typeof storedItem === "object" && storedItem.id === item.id
      })
      if (idIndex !== -1) {
        return idIndex
      }
      if (Number.isInteger(item._rawIndex) && item._rawIndex >= 0 && item._rawIndex < storedItems.length) {
        return item._rawIndex
      }
      return -1
    },
    sortTodoItems(items) {
      return [...items].sort((a, b) => {
        const dateA = this.getTodoDateValue(a)
        const dateB = this.getTodoDateValue(b)
        if (dateA !== dateB) {
          return dateA - dateB
        }
        return this.getTodoFallbackValue(a) - this.getTodoFallbackValue(b)
      })
    },
    getTodoDueDate(item) {
      return item ? (item.dueDate || item.deadline || item.time || "") : ""
    },
    getTodoDateValue(item) {
      const date = this.parseTodoDate(this.getTodoDueDate(item))
      return date ? date.getTime() : Number.MAX_SAFE_INTEGER
    },
    getTodoFallbackValue(item) {
      const value = item.updatedAt || item.createdAt || item.id || ""
      const time = Date.parse(value)
      return Number.isNaN(time) ? 0 : time
    },
    parseTodoDate(value) {
      if (!value) {
        return null
      }
      const matched = String(value).match(/^(\d{4})-(\d{2})-(\d{2})/)
      if (!matched) {
        return null
      }
      return new Date(Number(matched[1]), Number(matched[2]) - 1, Number(matched[3]))
    },
    todayStart() {
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      return today
    },
    isTodoDone(item) {
      const status = String(item && item.status || "").toLowerCase()
      return ["done", "completed", "finished", "complete", "1", "已完成"].includes(status)
    },
    isTodoOverdue(item) {
      const date = this.parseTodoDate(this.getTodoDueDate(item))
      return !this.isTodoDone(item) && date && date.getTime() < this.todayStart().getTime()
    },
    isTodoToday(item) {
      const date = this.parseTodoDate(this.getTodoDueDate(item))
      return !this.isTodoDone(item) && date && date.getTime() === this.todayStart().getTime()
    },
    todoDueText(item) {
      const dueDate = this.getTodoDueDate(item)
      return dueDate ? `截止 ${dueDate}` : "未设置截止日期"
    },
    todoStatusText(item) {
      const status = item && item.status
      const option = this.todoStatusOptions.find(item => item.value === status)
      return option ? option.label : "待办"
    },
    todoStatusTag(item) {
      const status = item && item.status
      if (status === "done") {
        return "success"
      }
      return "info"
    },
    todoItemClass(item) {
      return {
        "memo-item--done": this.isTodoDone(item),
        "memo-item--overdue": this.isTodoOverdue(item),
        "memo-item--today": this.isTodoToday(item)
      }
    },
    formatDateTime(date) {
      const pad = value => String(value).padStart(2, "0")
      return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`
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

.todo-stats {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 12px;
  padding: 12px;
  margin-bottom: 16px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
}

.todo-stat {
  min-height: 64px;
  padding: 10px 14px;
  background: transparent;
  border-left: 4px solid #cbd5e1;
}

.todo-stat__label {
  display: block;
  color: #64748b;
  font-size: 13px;
}

.todo-stat strong {
  display: block;
  margin-top: 8px;
  color: #111827;
  font-size: 24px;
  line-height: 1;
}

.todo-stat--today {
  border-left-color: #e6a23c;
}

.todo-stat--done {
  border-left-color: #67c23a;
}

.todo-stat--overdue {
  border-left-color: #f56c6c;
}

.quick-add {
  padding: 14px 14px 10px;
  margin-bottom: 16px;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
}

.quick-add__actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
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

.memo-item--overdue {
  border-color: #f56c6c;
}

.memo-item--today {
  border-color: #e6a23c;
}

.memo-item--done {
  background: #f8fafc;
}

.memo-item--done h3,
.memo-item--done p {
  color: #94a3b8;
}

.memo-item__top,
.memo-detail__meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
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

.memo-detail--form {
  padding-right: 16px;
}

.todo-detail-meta {
  padding-left: 86px;
}

.memo-dialog-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.memo-dialog-footer__right {
  display: flex;
  gap: 8px;
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

  .todo-stats {
    grid-template-columns: 1fr;
  }

  .todo-detail-meta {
    padding-left: 0;
  }

  .memo-dialog-footer {
    align-items: stretch;
    flex-direction: column-reverse;
  }

  .memo-dialog-footer__right {
    justify-content: flex-end;
  }
}
</style>
