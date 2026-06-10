<template>
  <el-dialog
    title="批量导入试题"
    :visible.sync="dialogVisible"
    width="650px"
    append-to-body
    :close-on-click-modal="false"
    @close="onClose"
  >
    <div class="import-container">
      <el-alert type="info" :closable="false" show-icon class="mb16">
        <template slot="title">
          请按模板格式填写题目信息，支持题型：<strong>单选题、多选题、判断题、填空题、简答题</strong>
        </template>
      </el-alert>

      <el-form label-width="90px" size="small">
        <el-form-item label="目标题库">
          <el-input :value="bankName" disabled />
        </el-form-item>
        <el-form-item label="模板下载">
          <el-button type="text" icon="el-icon-download" @click="downloadTemplate">下载导入模板 (Excel)</el-button>
        </el-form-item>
        <el-form-item label="选择文件">
          <el-upload
            ref="upload"
            :action="''"
            :auto-upload="false"
            :limit="1"
            :file-list="fileList"
            :on-change="onFileChange"
            :on-remove="onFileRemove"
            accept=".xlsx,.xls"
          >
            <el-button size="small" type="primary" icon="el-icon-upload">选择 Excel 文件</el-button>
            <span slot="tip" class="ml8">仅支持 .xlsx / .xls 格式</span>
          </el-upload>
        </el-form-item>
      </el-form>

      <div class="import-template-preview">
        <div class="import-template-preview__title">模板列说明</div>
        <el-table :data="columnDesc" size="mini" border>
          <el-table-column label="列" prop="col" width="60" align="center" />
          <el-table-column label="字段" prop="field" width="90" />
          <el-table-column label="说明" prop="desc" min-width="200" />
          <el-table-column label="必填" prop="required" width="55" align="center" />
        </el-table>
      </div>
    </div>

    <div slot="footer" class="dialog-footer">
      <el-button @click="dialogVisible = false">取 消</el-button>
      <el-button type="primary" :loading="submitting" :disabled="!selectedFile" @click="handleImport">
        开始导入
      </el-button>
    </div>
  </el-dialog>
</template>

<script>
import { importQuestions } from "@/api/edu/question"

export default {
  name: "ImportDialog",
  props: {
    visible: { type: Boolean, default: false },
    bankId: { type: [Number, String], required: true },
    bankName: { type: String, default: "" }
  },
  data() {
    return {
      submitting: false,
      fileList: [],
      selectedFile: null,
      columnDesc: [
        { col: "A", field: "题型", desc: "单选题 / 多选题 / 判断题 / 填空题 / 简答题", required: "是" },
        { col: "B", field: "题干", desc: "题目内容", required: "是" },
        { col: "C", field: "选项", desc: "选择题用 | 分隔，如：选项一|选项二|选项三|选项四；其他题型留空", required: "选择" },
        { col: "D", field: "正确答案", desc: "选择题填字母(A/B/C/D)，多选用逗号分隔；判断填正确/错误；填空简答填文本", required: "选择" },
        { col: "E", field: "难度", desc: "简单 / 中等 / 困难（默认中等）", required: "否" },
        { col: "F", field: "分值", desc: "数字（默认按题型：单选2/多选3/判断2/填空3/简答10）", required: "否" },
        { col: "G", field: "答案解析", desc: "题目解析文本", required: "否" }
      ]
    }
  },
  computed: {
    dialogVisible: {
      get() { return this.visible },
      set(v) { this.$emit("update:visible", v) }
    }
  },
  methods: {
    onClose() {
      this.fileList = []
      this.selectedFile = null
    },
    onFileChange(file) {
      this.selectedFile = file.raw
      this.fileList = [file]
    },
    onFileRemove() {
      this.selectedFile = null
    },
    handleImport() {
      if (!this.selectedFile) {
        this.$message.warning("请先选择 Excel 文件")
        return
      }
      this.submitting = true
      const formData = new FormData()
      formData.append("file", this.selectedFile)
      formData.append("bankId", this.bankId)

      importQuestions(formData).then(res => {
        this.$modal.msgSuccess(res.msg || "导入成功")
        this.dialogVisible = false
        this.$emit("imported")
      }).catch(() => {
        // 错误信息由拦截器展示
      }).finally(() => {
        this.submitting = false
      })
    },
    downloadTemplate() {
      // 走统一下载方法，确保携带登录 token。
      this.download("/edu/exam/question/import/template", {}, "试题导入模板.xlsx", { method: "get" })
    }
  }
}
</script>

<style lang="scss" scoped>
.import-container {
  .mb16 {
    margin-bottom: 16px;
  }
  .ml8 {
    margin-left: 8px;
  }
}

.import-template-preview {
  margin-top: 10px;
  border: 1px solid #e4e7ed;
  border-radius: 6px;
  padding: 12px;
  background: #fafafa;
}

.import-template-preview__title {
  font-weight: 600;
  margin-bottom: 8px;
  color: #303133;
}
</style>
