<template>
  <el-dialog
    :title="'组卷 - ' + paperName"
    :visible.sync="dialogVisible"
    width="1100px"
    top="4vh"
    append-to-body
    :close-on-click-modal="false"
    @opened="onOpen"
    @close="onClose"
  >
    <div v-loading="loading" class="compose-container">
      <!-- 左侧：题库题目 -->
      <div class="compose-panel compose-panel--bank">
        <div class="compose-panel__header">
          <span class="compose-panel__title">题库题目</span>
          <span class="compose-panel__count">共 {{ bankTotal }} 题</span>
        </div>
        <el-form :inline="true" size="small" class="bank-filter">
          <el-form-item label="">
            <el-input v-model="bankQuery.questionTitle" placeholder="搜索题目" clearable style="width: 160px" @keyup.enter.native="searchBankQuestions" />
          </el-form-item>
          <el-form-item label="">
            <el-select v-model="bankQuery.questionType" placeholder="题型" clearable style="width: 110px" @change="searchBankQuestions">
              <el-option label="单选题" value="1" />
              <el-option label="多选题" value="2" />
              <el-option label="判断题" value="3" />
              <el-option label="填空题" value="4" />
              <el-option label="简答题" value="5" />
            </el-select>
          </el-form-item>
          <el-form-item label="">
            <el-select v-model="bankQuery.difficultyLevel" placeholder="难度" clearable style="width: 100px" @change="searchBankQuestions">
              <el-option label="简单" value="1" />
              <el-option label="中等" value="2" />
              <el-option label="困难" value="3" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" @click="searchBankQuestions">搜索</el-button>
          </el-form-item>
        </el-form>
        <el-table
          ref="bankTable"
          :data="bankQuestions"
          height="380"
          size="small"
          @selection-change="onBankSelectionChange"
        >
          <el-table-column type="selection" width="42" />
          <el-table-column label="题目" prop="questionTitle" min-width="200" show-overflow-tooltip />
          <el-table-column label="题型" width="80" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="typeTag(scope.row.questionType)">{{ scope.row.questionType | typeName }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="难度" width="70" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="diffTag(scope.row.difficultyLevel)">{{ scope.row.difficultyLevel | diffName }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="分值" prop="score" width="70" align="center" />
        </el-table>
        <el-pagination
          small
          layout="prev, pager, next"
          :total="bankTotal"
          :page-size="bankQuery.pageSize"
          :current-page.sync="bankQuery.pageNum"
          @current-change="searchBankQuestions"
          style="text-align: center; margin-top: 10px"
        />
        <div class="compose-panel__actions">
          <el-button type="primary" size="small" :disabled="bankSelection.length === 0" @click="addToPaper">
            添加到试卷
          </el-button>
          <span v-if="bankSelection.length > 0" class="selected-hint">已选 {{ bankSelection.length }} 题</span>
        </div>
      </div>

      <!-- 右侧：已选题目 -->
      <div class="compose-panel compose-panel--paper">
        <div class="compose-panel__header">
          <span class="compose-panel__title">已选题目</span>
          <span class="compose-panel__count">共 {{ paperQuestions.length }} 题</span>
        </div>
        <el-table :data="paperQuestions" height="380" size="small" row-key="questionId">
          <el-table-column label="序号" width="55" align="center">
            <template slot-scope="scope">
              <span>{{ scope.$index + 1 }}</span>
            </template>
          </el-table-column>
          <el-table-column label="题目" prop="questionTitle" min-width="180" show-overflow-tooltip />
          <el-table-column label="题型" width="80" align="center">
            <template slot-scope="scope">
              <el-tag size="mini" :type="typeTag(scope.row.questionType)">{{ scope.row.questionType | typeName }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="分值" width="100" align="center">
            <template slot-scope="scope">
              <el-input-number
                v-model="scope.row.questionScore"
                :min="0"
                :max="100"
                :precision="1"
                size="mini"
                controls-position="right"
                style="width: 85px"
                @change="onScoreChange"
              />
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" align="center">
            <template slot-scope="scope">
              <el-button type="text" icon="el-icon-top" :disabled="scope.$index === 0" @click="moveUp(scope.$index)" />
              <el-button type="text" icon="el-icon-bottom" :disabled="scope.$index === paperQuestions.length - 1" @click="moveDown(scope.$index)" />
              <el-button type="text" icon="el-icon-close" style="color: #f56c6c" @click="removeFromPaper(scope.$index)" />
            </template>
          </el-table-column>
        </el-table>
        <!-- 统计汇总 -->
        <div class="compose-stats">
          <div class="compose-stats__item">
            <strong>题目数</strong>
            <span class="compose-stats__value">{{ paperQuestions.length }}</span>
          </div>
          <div class="compose-stats__item">
            <strong>总分</strong>
            <span class="compose-stats__value compose-stats__value--primary">{{ computedTotal }}</span>
          </div>
          <div class="compose-stats__item">
            <strong>客观题</strong>
            <span class="compose-stats__value">{{ computedObjective }}</span>
          </div>
          <div class="compose-stats__item">
            <strong>主观题</strong>
            <span class="compose-stats__value">{{ computedSubjective }}</span>
          </div>
        </div>
      </div>
    </div>

    <div slot="footer" class="dialog-footer">
      <el-button @click="dialogVisible = false">取 消</el-button>
      <el-button type="primary" :loading="saving" @click="handleSave">保存组卷</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { listQuestion } from "@/api/edu/question"
import { listPaperQuestions, savePaperQuestions } from "@/api/edu/paper"

export default {
  name: "ComposeDialog",
  props: {
    visible: { type: Boolean, default: false },
    paperId: { type: Number, required: true },
    paperName: { type: String, default: "" },
    bankId: { type: Number, required: true }
  },
  filters: {
    typeName(val) {
      const map = { "1": "单选", "2": "多选", "3": "判断", "4": "填空", "5": "简答" }
      return map[val] || "未知"
    },
    diffName(val) {
      const map = { "1": "简单", "2": "中等", "3": "困难" }
      return map[val] || "未知"
    }
  },
  data() {
    return {
      loading: false,
      saving: false,
      bankQuestions: [],
      bankSelection: [],
      bankTotal: 0,
      bankQuery: {
        pageNum: 1,
        pageSize: 10,
        questionTitle: "",
        questionType: undefined,
        difficultyLevel: undefined
      },
      paperQuestions: []
    }
  },
  computed: {
    dialogVisible: {
      get() { return this.visible },
      set(v) { this.$emit("update:visible", v) }
    },
    computedTotal() {
      return this.paperQuestions.reduce((sum, q) => sum + (Number(q.questionScore) || 0), 0).toFixed(1)
    },
    computedObjective() {
      return this.paperQuestions
        .filter(q => ["1", "2", "3", "4"].includes(q.questionType))
        .reduce((sum, q) => sum + (Number(q.questionScore) || 0), 0)
        .toFixed(1)
    },
    computedSubjective() {
      return this.paperQuestions
        .filter(q => ["5"].includes(q.questionType))
        .reduce((sum, q) => sum + (Number(q.questionScore) || 0), 0)
        .toFixed(1)
    }
  },
  methods: {
    onOpen() {
      this.loading = true
      Promise.all([
        this.searchBankQuestions(),
        this.loadPaperQuestions()
      ]).finally(() => {
        this.loading = false
      })
    },
    onClose() {
      this.bankQuery = { pageNum: 1, pageSize: 10, questionTitle: "", questionType: undefined, difficultyLevel: undefined }
      this.bankQuestions = []
      this.bankSelection = []
      this.paperQuestions = []
    },
    /** 搜索题库题目 */
    searchBankQuestions() {
      return listQuestion({
        pageNum: this.bankQuery.pageNum,
        pageSize: this.bankQuery.pageSize,
        bankId: this.bankId,
        questionTitle: this.bankQuery.questionTitle || undefined,
        questionType: this.bankQuery.questionType,
        difficultyLevel: this.bankQuery.difficultyLevel,
        status: "0"
      }).then(res => {
        this.bankQuestions = res.rows || []
        this.bankTotal = res.total || 0
      })
    },
    /** 加载试卷已有题目 */
    loadPaperQuestions() {
      return listPaperQuestions(this.paperId).then(res => {
        this.paperQuestions = (res.data || []).map(q => ({
          ...q,
          questionScore: q.questionScore != null ? q.questionScore : (q.originalScore || 0)
        }))
      })
    },
    /** 从题库添加到试卷（去重） */
    addToPaper() {
      const existingIds = new Set(this.paperQuestions.map(q => q.questionId))
      const toAdd = this.bankSelection.filter(q => !existingIds.has(q.questionId))
      if (toAdd.length === 0) {
        this.$message.warning("所选题目已在试卷中")
        return
      }
      const mapped = toAdd.map(q => ({
        questionId: q.questionId,
        questionTitle: q.questionTitle,
        questionType: q.questionType,
        difficultyLevel: q.difficultyLevel,
        questionScore: q.score || 0,
        originalScore: q.score
      }))
      this.paperQuestions = [...this.paperQuestions, ...mapped]
      this.$refs.bankTable.clearSelection()
      this.bankSelection = []
    },
    /** 从试卷移除题目 */
    removeFromPaper(index) {
      this.paperQuestions.splice(index, 1)
    },
    /** 上移 */
    moveUp(index) {
      if (index <= 0) return
      const arr = this.paperQuestions
      const item = arr.splice(index, 1)[0]
      arr.splice(index - 1, 0, item)
    },
    /** 下移 */
    moveDown(index) {
      if (index >= this.paperQuestions.length - 1) return
      const arr = this.paperQuestions
      const item = arr.splice(index, 1)[0]
      arr.splice(index + 1, 0, item)
    },
    onBankSelectionChange(selection) {
      this.bankSelection = selection
    },
    onScoreChange() {
      // 触发响应式更新，computed 自动重算
    },
    typeTag(type) {
      const map = { "1": "", "2": "success", "3": "warning", "4": "info", "5": "danger" }
      return map[type] || "info"
    },
    diffTag(level) {
      const map = { "1": "success", "2": "warning", "3": "danger" }
      return map[level] || "info"
    },
    /** 保存组卷 */
    handleSave() {
      if (this.paperQuestions.length === 0) {
        this.$message.warning("试卷中还没有题目，请先从左侧题库添加题目后再保存")
        return
      }
      this.doSave()
    },
    doSave() {
      this.saving = true
      const payload = this.paperQuestions.map((q, i) => ({
        questionId: q.questionId,
        questionOrder: i + 1,
        questionScore: q.questionScore,
        questionType: q.questionType,
        difficultyLevel: q.difficultyLevel
      }))
      savePaperQuestions(this.paperId, payload).then(() => {
        this.$modal.msgSuccess("组卷成功")
        this.dialogVisible = false
        this.$emit("saved")
      }).catch(() => {
        this.$modal.msgError("组卷失败")
      }).finally(() => {
        this.saving = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.compose-container {
  display: flex;
  gap: 16px;
  min-height: 520px;
}

.compose-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  padding: 12px;
  background: #fafafa;
}

.compose-panel__header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.compose-panel__title {
  font-weight: 600;
  color: #303133;
}

.compose-panel__count {
  font-size: 12px;
  color: #909399;
}

.bank-filter {
  margin-bottom: 6px;
}

.bank-filter .el-form-item {
  margin-bottom: 4px;
  margin-right: 4px;
}

.compose-panel__actions {
  margin-top: 10px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.selected-hint {
  font-size: 12px;
  color: #67c23a;
}

.compose-stats {
  display: flex;
  gap: 24px;
  margin-top: 12px;
  padding: 10px 14px;
  background: #ecf5ff;
  border-radius: 6px;
}

.compose-stats__item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.compose-stats__item strong {
  font-size: 12px;
  color: #606266;
  margin-bottom: 2px;
}

.compose-stats__value {
  font-size: 18px;
  font-weight: 700;
  color: #303133;
}

.compose-stats__value--primary {
  color: #409eff;
}
</style>
