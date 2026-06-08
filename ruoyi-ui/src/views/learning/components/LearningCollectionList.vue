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
      <div class="collection-actions">
        <el-input
          v-model.trim="keyword"
          class="collection-search"
          size="small"
          clearable
          prefix-icon="el-icon-search"
          placeholder="搜索课程、标题或内容"
        />
        <el-button
          v-if="allowWrongQuestionAdd"
          type="success"
          size="small"
          icon="el-icon-plus"
          @click="openWrongAdd"
        >添加错题</el-button>
      </div>
    </div>

    <el-form
      v-if="allowWrongQuestionAdd && wrongAddOpen"
      ref="wrongAddForm"
      :model="wrongAddForm"
      :rules="wrongAddRules"
      class="wrong-add"
      label-width="88px"
    >
      <el-form-item label="错题文字" prop="questionStem">
        <el-input
          v-model.trim="wrongAddForm.questionStem"
          type="textarea"
          :rows="4"
          maxlength="1000"
          show-word-limit
          placeholder="输入题干、题目描述或粘贴错题文字"
        />
      </el-form-item>
      <el-form-item label="错题图片" prop="questionImage">
        <image-upload
          v-model="wrongAddForm.questionImage"
          :limit="1"
          :file-size="10"
          directory="student/wrong"
        />
      </el-form-item>
      <el-form-item label="我的答案">
        <el-input
          v-model.trim="wrongAddForm.myAnswer"
          type="textarea"
          :rows="2"
          maxlength="500"
          show-word-limit
          placeholder="记录当时写错的答案"
        />
      </el-form-item>
      <el-form-item label="正确答案">
        <el-input
          v-model.trim="wrongAddForm.correctAnswer"
          type="textarea"
          :rows="2"
          maxlength="500"
          show-word-limit
          placeholder="记录正确答案"
        />
      </el-form-item>
      <el-form-item label="解析">
        <el-input
          v-model.trim="wrongAddForm.analysis"
          type="textarea"
          :rows="3"
          maxlength="1000"
          show-word-limit
          placeholder="记录错因、知识点或订正思路"
        />
      </el-form-item>
      <div class="wrong-add__actions">
        <el-button size="small" @click="wrongAddOpen = false">取消</el-button>
        <el-button
          type="primary"
          size="small"
          :loading="wrongAddSaving"
          @click="addWrongQuestion"
        >保存错题</el-button>
      </div>
    </el-form>

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
        <img
          v-if="item.questionImage || item.imageUrl"
          class="collection-item__image"
          :src="resolveImageUrl(item.questionImage || item.imageUrl)"
          alt="错题图片"
        />
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
        <section v-if="activeItem.questionImage || activeItem.imageUrl">
          <h4>错题图片</h4>
          <img
            class="detail-image"
            :src="resolveImageUrl(activeItem.questionImage || activeItem.imageUrl)"
            alt="错题图片"
          />
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
import { getStudentProfile, updateStudentProfile } from "@/api/system/user"
import ImageUpload from "@/components/ImageUpload"
import { resolveResourceUrl } from "@/utils/resource"

export default {
  name: "LearningCollectionList",
  components: { ImageUpload },
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
    },
    allowWrongQuestionAdd: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      loading: false,
      keyword: "",
      form: {},
      items: [],
      activeItem: null,
      detailOpen: false,
      wrongAddOpen: false,
      wrongAddSaving: false,
      wrongAddForm: {
        questionStem: "",
        questionImage: "",
        myAnswer: "",
        correctAnswer: "",
        analysis: ""
      },
      wrongAddRules: {
        questionStem: [
          { validator: this.validateWrongQuestionContent, trigger: "blur" }
        ],
        questionImage: [
          { validator: this.validateWrongQuestionContent, trigger: "change" }
        ]
      }
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
        this.form = res.data || {}
        this.items = this.parseItems(this.form[this.field])
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
          detail: value,
          summary: value,
          tags: ["历史文本"]
        }]
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
          title: item.title || item.questionTitle || item.contentTitle || this.createTitle(item.questionStem) || `第 ${index + 1} 条记录`,
          summary: item.summary || item.reason || item.note || item.content || item.detail || item.questionStem || "",
          tags
        }
      })
    },
    createTitle(text) {
      const value = String(text || "").trim()
      if (!value) {
        return ""
      }
      return value.length > 28 ? `${value.slice(0, 28)}...` : value
    },
    openDetail(item) {
      this.activeItem = item
      this.detailOpen = true
    },
    openWrongAdd() {
      this.wrongAddOpen = true
      this.$nextTick(() => {
        if (this.$refs.wrongAddForm) {
          this.$refs.wrongAddForm.clearValidate()
        }
      })
    },
    validateWrongQuestionContent(rule, value, callback) {
      if (this.wrongAddForm.questionStem || this.wrongAddForm.questionImage) {
        callback()
        return
      }
      callback(new Error("请填写错题文字或上传错题图片"))
    },
    resetWrongAddForm() {
      this.wrongAddForm = {
        questionStem: "",
        questionImage: "",
        myAnswer: "",
        correctAnswer: "",
        analysis: ""
      }
      if (this.$refs.wrongAddForm) {
        this.$refs.wrongAddForm.clearValidate()
      }
    },
    addWrongQuestion() {
      this.$refs.wrongAddForm.validate(valid => {
        if (!valid) {
          return
        }
        const now = new Date()
        const pad = value => String(value).padStart(2, "0")
        const createdAt = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
        const storedItems = this.parseStoredList(this.form[this.field])
        const title = this.createTitle(this.wrongAddForm.questionStem) || "图片错题"
        const item = {
          id: `wrong-${now.getTime()}`,
          title,
          questionStem: this.wrongAddForm.questionStem,
          questionImage: this.wrongAddForm.questionImage,
          myAnswer: this.wrongAddForm.myAnswer,
          correctAnswer: this.wrongAddForm.correctAnswer,
          analysis: this.wrongAddForm.analysis,
          createdAt,
          updatedAt: createdAt,
          tags: [this.wrongAddForm.questionImage ? "图片错题" : "文字错题"]
        }
        storedItems.unshift(item)
        this.form[this.field] = JSON.stringify(storedItems, null, 2)
        this.wrongAddSaving = true
        updateStudentProfile(this.form).then(() => {
          this.items = this.parseItems(this.form[this.field])
          this.wrongAddOpen = false
          this.resetWrongAddForm()
          this.$modal.msgSuccess("保存成功")
        }).finally(() => {
          this.wrongAddSaving = false
        })
      })
    },
    resolveImageUrl(url) {
      return resolveResourceUrl(url)
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

.collection-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.wrong-add {
  padding: 16px 16px 12px;
  margin-bottom: 16px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
}

.wrong-add__actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
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

.collection-item__image {
  width: 100%;
  max-height: 160px;
  margin-top: 12px;
  object-fit: contain;
  background: #f8fafc;
  border: 1px solid #e5e7eb;
  border-radius: 4px;
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

.detail-image {
  display: block;
  max-width: 100%;
  max-height: 520px;
  object-fit: contain;
  border: 1px solid #e5e7eb;
  border-radius: 4px;
}

@media (max-width: 768px) {
  .collection-header {
    flex-direction: column;
  }

  .collection-actions {
    align-items: stretch;
    flex-direction: column;
    width: 100%;
  }

  .collection-search {
    width: 100%;
  }

  .collection-list {
    grid-template-columns: 1fr;
  }
}
</style>
