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
        <el-button
          v-if="allowCourseFavoriteAdd"
          type="warning"
          size="small"
          icon="el-icon-star-on"
          @click="openCourseFavorite"
        >收藏课程</el-button>
        <el-button
          v-if="allowLearningNoteAdd"
          type="success"
          size="small"
          icon="el-icon-edit"
          @click="openNoteAdd"
        >添加笔记</el-button>
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

    <el-dialog
      title="收藏课程"
      :visible.sync="favoriteDialogOpen"
      width="860px"
      append-to-body
    >
      <div class="favorite-picker">
        <div class="favorite-picker__toolbar">
          <el-input
            v-model.trim="courseQuery.courseName"
            clearable
            prefix-icon="el-icon-search"
            placeholder="搜索课程名称"
            @keyup.enter.native="loadCourseOptions"
          />
          <el-button type="primary" :loading="courseLoading" @click="loadCourseOptions">搜索</el-button>
        </div>
        <el-table
          v-loading="courseLoading"
          :data="courseOptions"
          height="420"
          border
        >
          <el-table-column label="课程" min-width="260">
            <template slot-scope="scope">
              <div class="course-option">
                <img
                  v-if="scope.row.coverImage"
                  :src="resolveImageUrl(scope.row.coverImage)"
                  :alt="scope.row.courseName"
                />
                <div v-else class="course-option__fallback">{{ getCourseShortName(scope.row.courseName) }}</div>
                <div>
                  <strong>{{ scope.row.courseName }}</strong>
                  <p>{{ scope.row.courseSubtitle || scope.row.intro || "暂无简介" }}</p>
                </div>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="categoryName" label="分类" width="140" />
          <el-table-column prop="teacherName" label="教师" width="140" />
          <el-table-column label="数据" width="150">
            <template slot-scope="scope">
              <span>{{ scope.row.enrollCount || 0 }} 人学习</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right">
            <template slot-scope="scope">
              <el-button
                type="text"
                :disabled="isCourseFavorited(scope.row.courseId)"
                @click="addCourseFavorite(scope.row)"
              >{{ isCourseFavorited(scope.row.courseId) ? "已收藏" : "收藏" }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <pagination
          v-show="courseTotal > 0"
          :total="courseTotal"
          :page.sync="courseQuery.pageNum"
          :limit.sync="courseQuery.pageSize"
          @pagination="loadCourseOptions"
        />
      </div>
    </el-dialog>

    <el-form
      v-if="allowLearningNoteAdd && noteAddOpen"
      ref="noteAddForm"
      :model="noteAddForm"
      :rules="noteAddRules"
      class="note-add"
      label-width="88px"
    >
      <el-form-item label="标题" prop="title">
        <el-input
          v-model.trim="noteAddForm.title"
          maxlength="80"
          show-word-limit
          placeholder="输入笔记标题"
        />
      </el-form-item>
      <el-form-item label="课程">
        <el-input
          v-model.trim="noteAddForm.courseName"
          maxlength="80"
          show-word-limit
          placeholder="可选，填写关联课程"
        />
      </el-form-item>
      <el-form-item label="内容" prop="content">
        <el-input
          v-model.trim="noteAddForm.content"
          type="textarea"
          :rows="6"
          maxlength="2000"
          show-word-limit
          placeholder="记录学习重点、疑问、总结或复习要点"
        />
      </el-form-item>
      <div class="note-add__actions">
        <el-button size="small" @click="noteAddOpen = false">取消</el-button>
        <el-button
          type="primary"
          size="small"
          :loading="noteAddSaving"
          @click="addLearningNote"
        >保存笔记</el-button>
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
          <span>{{ formatItemTime(item) }}</span>
        </div>
        <h3>{{ item.title }}</h3>
        <div class="collection-item__course">
          <i class="el-icon-reading"></i>
          <span>{{ item.courseName || "未关联课程" }}</span>
        </div>
        <img
          v-if="item.questionImage || item.imageUrl || item.coverImage"
          class="collection-item__image"
          :src="resolveImageUrl(item.questionImage || item.imageUrl || item.coverImage)"
          :alt="item.courseName || item.title"
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
          <span v-if="activeItem.lastEditTime || activeItem.updatedAt">最后编辑：{{ activeItem.lastEditTime || activeItem.updatedAt }}</span>
          <span v-else-if="activeItem.collectedAt">{{ activeItem.collectedAt }}</span>
        </div>

        <el-form
          v-if="wrongEditMode"
          ref="wrongEditForm"
          :model="wrongEditForm"
          :rules="wrongEditRules"
          class="wrong-edit"
          label-width="88px"
        >
          <el-form-item label="错题文字" prop="questionStem">
            <el-input
              v-model.trim="wrongEditForm.questionStem"
              type="textarea"
              :rows="4"
              maxlength="1000"
              show-word-limit
              placeholder="输入题干、题目描述或粘贴错题文字"
            />
          </el-form-item>
          <el-form-item label="错题图片" prop="questionImage">
            <image-upload
              v-model="wrongEditForm.questionImage"
              :limit="1"
              :file-size="10"
              directory="student/wrong"
            />
          </el-form-item>
          <el-form-item label="我的答案">
            <el-input
              v-model.trim="wrongEditForm.myAnswer"
              type="textarea"
              :rows="2"
              maxlength="500"
              show-word-limit
              placeholder="记录当时写错的答案"
            />
          </el-form-item>
          <el-form-item label="正确答案">
            <el-input
              v-model.trim="wrongEditForm.correctAnswer"
              type="textarea"
              :rows="2"
              maxlength="500"
              show-word-limit
              placeholder="记录正确答案"
            />
          </el-form-item>
          <el-form-item label="解析">
            <el-input
              v-model.trim="wrongEditForm.analysis"
              type="textarea"
              :rows="3"
              maxlength="1000"
              show-word-limit
              placeholder="记录错因、知识点或订正思路"
            />
          </el-form-item>
        </el-form>

        <template v-else>
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
          <section v-if="activeItem.courseId">
            <h4>课程操作</h4>
            <el-button
              v-if="canOpenLearningNoteSource"
              type="success"
              size="small"
              @click="openLearningNoteSource(activeItem)"
            >进入内容笔记</el-button>
            <el-button type="primary" size="small" @click="openCourse(activeItem.courseId)">查看课程</el-button>
          </section>
        </template>
      </div>
      <span v-if="activeItem && canManageWrongQuestions" slot="footer" class="wrong-detail-actions">
        <template v-if="wrongEditMode">
          <el-button size="small" @click="cancelWrongEdit">取消</el-button>
          <el-button
            type="primary"
            size="small"
            :loading="wrongEditSaving"
            @click="saveWrongQuestion"
          >保存</el-button>
        </template>
        <template v-else>
          <el-button
            type="danger"
            size="small"
            :loading="wrongDeleteSaving"
            @click="deleteWrongQuestion"
          >删除</el-button>
          <el-button type="primary" size="small" @click="openWrongEdit">编辑</el-button>
        </template>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getStudentProfile, updateStudentProfile } from "@/api/system/user"
import { listPortalCourses } from "@/api/portal"
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
    },
    allowCourseFavoriteAdd: {
      type: Boolean,
      default: false
    },
    allowLearningNoteAdd: {
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
      },
      wrongEditMode: false,
      wrongEditSaving: false,
      wrongDeleteSaving: false,
      wrongEditForm: {
        questionStem: "",
        questionImage: "",
        myAnswer: "",
        correctAnswer: "",
        analysis: ""
      },
      wrongEditRules: {
        questionStem: [
          { validator: this.validateWrongEditContent, trigger: "blur" }
        ],
        questionImage: [
          { validator: this.validateWrongEditContent, trigger: "change" }
        ]
      },
      favoriteDialogOpen: false,
      courseLoading: false,
      courseOptions: [],
      courseTotal: 0,
      courseQuery: {
        pageNum: 1,
        pageSize: 10,
        courseName: ""
      },
      noteAddOpen: false,
      noteAddSaving: false,
      noteAddForm: {
        title: "",
        courseName: "",
        content: ""
      },
      noteAddRules: {
        title: [
          { required: true, message: "请输入笔记标题", trigger: "blur" }
        ],
        content: [
          { required: true, message: "请输入笔记内容", trigger: "blur" }
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
          item.courseSubtitle,
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
    },
    canManageWrongQuestions() {
      return this.allowWrongQuestionAdd && this.field === "wrongQuestions"
    },
    canOpenLearningNoteSource() {
      return this.field === "learningNotes" && this.activeItem && this.activeItem.courseId && this.activeItem.contentId
    }
  },
  created() {
    this.load()
  },
  watch: {
    detailOpen(value) {
      if (!value) {
        this.wrongEditMode = false
        this.resetWrongEditForm()
      }
    }
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
      if (Array.isArray(raw)) {
        return raw
      }
      if (raw && typeof raw === "object" && Array.isArray(raw.items)) {
        return raw.items
      }
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
          title: item.title || item.questionTitle || item.contentTitle || item.courseName || this.createTitle(item.questionStem) || `第 ${index + 1} 条记录`,
          summary: item.summary || item.reason || item.note || item.content || item.detail || item.courseSubtitle || item.intro || item.questionStem || "",
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
    createTimestamp() {
      const now = new Date()
      const pad = value => String(value).padStart(2, "0")
      return `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
    },
    formatItemTime(item) {
      const time = item.lastEditTime || item.updatedAt || item.collectedAt || item.createdAt
      if (!time) {
        return "未记录时间"
      }
      return item.lastEditTime || item.updatedAt ? `最后编辑：${time}` : time
    },
    normalizeTagList(tags) {
      return Array.isArray(tags)
        ? tags
        : String(tags || "").split(",").map(tag => tag.trim()).filter(Boolean)
    },
    openDetail(item) {
      this.activeItem = item
      this.wrongEditMode = false
      this.resetWrongEditForm()
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
    validateWrongEditContent(rule, value, callback) {
      if (this.wrongEditForm.questionStem || this.wrongEditForm.questionImage) {
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
    resetWrongEditForm() {
      this.wrongEditForm = {
        questionStem: "",
        questionImage: "",
        myAnswer: "",
        correctAnswer: "",
        analysis: ""
      }
      if (this.$refs.wrongEditForm) {
        this.$refs.wrongEditForm.clearValidate()
      }
    },
    addWrongQuestion() {
      this.$refs.wrongAddForm.validate(valid => {
        if (!valid) {
          return
        }
        const createdAt = this.createTimestamp()
        const storedItems = this.parseStoredList(this.form[this.field])
        const title = this.createTitle(this.wrongAddForm.questionStem) || "图片错题"
        const item = {
          id: `wrong-${Date.now()}`,
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
    openWrongEdit() {
      if (!this.activeItem) {
        return
      }
      this.wrongEditForm = {
        questionStem: this.activeItem.questionStem || "",
        questionImage: this.activeItem.questionImage || this.activeItem.imageUrl || "",
        myAnswer: this.activeItem.myAnswer || "",
        correctAnswer: this.activeItem.correctAnswer || "",
        analysis: this.activeItem.analysis || ""
      }
      this.wrongEditMode = true
      this.$nextTick(() => {
        if (this.$refs.wrongEditForm) {
          this.$refs.wrongEditForm.clearValidate()
        }
      })
    },
    cancelWrongEdit() {
      this.wrongEditMode = false
      this.resetWrongEditForm()
    },
    findStoredItemIndex(storedItems, item) {
      const id = String((item && item.id) || "")
      let index = storedItems.findIndex(storedItem => String(storedItem.id || "") === id)
      if (index === -1) {
        const normalizedItems = this.normalizeItems(storedItems)
        index = normalizedItems.findIndex(storedItem => String(storedItem.id || "") === id)
      }
      if (index === -1) {
        index = this.items.findIndex(displayItem => displayItem === item || String(displayItem.id || "") === id)
        if (index >= storedItems.length) {
          index = -1
        }
      }
      return index
    },
    saveWrongQuestion() {
      if (!this.$refs.wrongEditForm || !this.activeItem) {
        return
      }
      this.$refs.wrongEditForm.validate(valid => {
        if (!valid) {
          return
        }
        const storedItems = this.parseStoredList(this.form[this.field])
        const index = this.findStoredItemIndex(storedItems, this.activeItem)
        if (index === -1) {
          this.$modal.msgError("未找到要编辑的错题")
          return
        }
        const current = storedItems[index] || {}
        const questionImage = this.wrongEditForm.questionImage || ""
        const title = this.createTitle(this.wrongEditForm.questionStem) || current.title || this.activeItem.title || "图片错题"
        const existingTags = this.normalizeTagList(current.tags || this.activeItem.tags)
          .filter(tag => !["图片错题", "文字错题"].includes(tag))
        const updatedItem = {
          ...current,
          title,
          questionStem: this.wrongEditForm.questionStem,
          questionImage,
          imageUrl: questionImage,
          myAnswer: this.wrongEditForm.myAnswer,
          correctAnswer: this.wrongEditForm.correctAnswer,
          analysis: this.wrongEditForm.analysis,
          summary: this.wrongEditForm.questionStem || this.wrongEditForm.analysis || current.summary || "",
          updatedAt: this.createTimestamp(),
          tags: [questionImage ? "图片错题" : "文字错题", ...existingTags]
        }
        storedItems.splice(index, 1, updatedItem)
        this.form[this.field] = JSON.stringify(storedItems, null, 2)
        this.wrongEditSaving = true
        updateStudentProfile(this.form).then(() => {
          this.items = this.parseItems(this.form[this.field])
          this.activeItem = this.items.find(item => String(item.id) === String(updatedItem.id)) || this.items[index]
          this.wrongEditMode = false
          this.resetWrongEditForm()
          this.$modal.msgSuccess("保存成功")
        }).finally(() => {
          this.wrongEditSaving = false
        })
      })
    },
    deleteWrongQuestion() {
      if (!this.activeItem) {
        return
      }
      this.$modal.confirm("确认删除这道错题吗？").then(() => {
        const storedItems = this.parseStoredList(this.form[this.field])
        const index = this.findStoredItemIndex(storedItems, this.activeItem)
        if (index === -1) {
          this.$modal.msgError("未找到要删除的错题")
          return Promise.reject(new Error("wrong question not found"))
        }
        storedItems.splice(index, 1)
        this.form[this.field] = JSON.stringify(storedItems, null, 2)
        this.wrongDeleteSaving = true
        return updateStudentProfile(this.form).then(() => {
          this.items = this.parseItems(this.form[this.field])
          this.detailOpen = false
          this.activeItem = null
          this.$modal.msgSuccess("删除成功")
        }).finally(() => {
          this.wrongDeleteSaving = false
        })
      }).catch(() => {})
    },
    resolveImageUrl(url) {
      return resolveResourceUrl(url)
    },
    openCourseFavorite() {
      this.favoriteDialogOpen = true
      this.courseQuery.pageNum = 1
      this.loadCourseOptions()
    },
    loadCourseOptions() {
      this.courseLoading = true
      listPortalCourses(this.courseQuery).then(res => {
        this.courseOptions = res.rows || []
        this.courseTotal = res.total || 0
      }).finally(() => {
        this.courseLoading = false
      })
    },
    isCourseFavorited(courseId) {
      return this.items.some(item => String(item.courseId) === String(courseId))
    },
    getCourseShortName(name) {
      return (name || "课程").slice(0, 2)
    },
    addCourseFavorite(course) {
      if (this.isCourseFavorited(course.courseId)) {
        this.$modal.msgWarning("该课程已收藏")
        return
      }
      const now = new Date()
      const pad = value => String(value).padStart(2, "0")
      const collectedAt = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
      const storedItems = this.parseStoredList(this.form[this.field])
      const item = {
        id: `favorite-course-${course.courseId}`,
        courseId: course.courseId,
        title: course.courseName,
        courseName: course.courseName,
        courseSubtitle: course.courseSubtitle,
        coverImage: course.coverImage,
        categoryName: course.categoryName,
        teacherName: course.teacherName,
        summary: course.courseSubtitle || course.intro || "",
        detail: course.intro || "",
        collectedAt,
        updatedAt: collectedAt,
        tags: ["课程收藏"]
      }
      storedItems.unshift(item)
      this.form[this.field] = JSON.stringify(storedItems, null, 2)
      updateStudentProfile(this.form).then(() => {
        this.items = this.parseItems(this.form[this.field])
        this.$modal.msgSuccess("收藏成功")
      })
    },
    openCourse(courseId) {
      this.detailOpen = false
      this.$router.push(`/course/${courseId}`)
    },
    openLearningNoteSource(item) {
      this.detailOpen = false
      this.$router.push({
        path: "/learning/online",
        query: {
          courseId: item.courseId,
          contentId: item.contentId,
          edit: "1"
        }
      })
    },
    openNoteAdd() {
      this.noteAddOpen = true
      this.$nextTick(() => {
        if (this.$refs.noteAddForm) {
          this.$refs.noteAddForm.clearValidate()
        }
      })
    },
    resetNoteAddForm() {
      this.noteAddForm = {
        title: "",
        courseName: "",
        content: ""
      }
      if (this.$refs.noteAddForm) {
        this.$refs.noteAddForm.clearValidate()
      }
    },
    addLearningNote() {
      this.$refs.noteAddForm.validate(valid => {
        if (!valid) {
          return
        }
        const now = new Date()
        const pad = value => String(value).padStart(2, "0")
        const createdAt = `${now.getFullYear()}-${pad(now.getMonth() + 1)}-${pad(now.getDate())} ${pad(now.getHours())}:${pad(now.getMinutes())}`
        const storedItems = this.parseStoredList(this.form[this.field])
        const item = {
          id: `note-${now.getTime()}`,
          title: this.noteAddForm.title,
          courseName: this.noteAddForm.courseName,
          content: this.noteAddForm.content,
          summary: this.noteAddForm.content,
          createdAt,
          updatedAt: createdAt,
          tags: ["自建笔记"]
        }
        storedItems.unshift(item)
        this.form[this.field] = JSON.stringify(storedItems, null, 2)
        this.noteAddSaving = true
        updateStudentProfile(this.form).then(() => {
          this.items = this.parseItems(this.form[this.field])
          this.noteAddOpen = false
          this.resetNoteAddForm()
          this.$modal.msgSuccess("保存成功")
        }).finally(() => {
          this.noteAddSaving = false
        })
      })
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

.wrong-edit {
  padding-top: 4px;
}

.wrong-detail-actions {
  display: inline-flex;
  justify-content: flex-end;
  gap: 8px;
  width: 100%;
}

.note-add {
  padding: 16px 16px 12px;
  margin-bottom: 16px;
  background: #ffffff;
  border: 1px solid #e5e7eb;
  border-radius: 6px;
}

.note-add__actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}

.favorite-picker__toolbar {
  display: flex;
  gap: 10px;
  margin-bottom: 14px;
}

.course-option {
  display: flex;
  align-items: center;
  gap: 12px;
}

.course-option img,
.course-option__fallback {
  flex: 0 0 auto;
  width: 72px;
  height: 48px;
  border-radius: 4px;
}

.course-option img {
  object-fit: cover;
}

.course-option__fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #2563eb;
  font-weight: 700;
  background: #eff6ff;
}

.course-option strong {
  display: block;
  color: #111827;
}

.course-option p {
  margin: 5px 0 0;
  color: #6b7280;
  line-height: 1.5;
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
