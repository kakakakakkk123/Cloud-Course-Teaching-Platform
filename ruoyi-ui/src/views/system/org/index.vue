<template>
  <div class="app-container org-page">
    <el-row :gutter="16">
      <el-col :span="7">
        <div class="org-tree-panel">
          <div class="panel-title">
            <span>学院 / 专业 / 班级</span>
            <el-button type="text" icon="el-icon-refresh" @click="getTree">刷新</el-button>
          </div>
          <el-input v-model="filterText" size="small" clearable placeholder="搜索学院、专业或班级" prefix-icon="el-icon-search" />
          <el-tree
            ref="orgTree"
            class="org-tree"
            node-key="deptId"
            :data="treeData"
            :props="treeProps"
            :filter-node-method="filterNode"
            default-expand-all
            highlight-current
            @node-click="handleNodeClick"
          >
            <span slot-scope="{ node, data }" class="org-node">
              <i :class="node.level < 3 ? 'el-icon-folder-opened' : 'el-icon-document'" />
              <span>{{ node.label }}</span>
              <el-tag size="mini" effect="plain">{{ levelName(data) }}</el-tag>
            </span>
          </el-tree>
        </div>
      </el-col>
      <el-col :span="17">
        <div class="org-main">
          <div class="org-toolbar">
            <div>
              <h3>院系管理</h3>
              <p>仅允许三层结构：学院 -> 专业 -> 班级。班级下不能再创建层级。</p>
            </div>
            <div class="toolbar-actions">
              <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddRoot">新增学院</el-button>
              <el-button type="success" icon="el-icon-plus" size="mini" :disabled="!canAddChild" @click="handleAddChild">新增下级</el-button>
              <el-button type="warning" icon="el-icon-edit" size="mini" :disabled="!currentNode" @click="handleEdit">编辑</el-button>
              <el-button type="danger" icon="el-icon-delete" size="mini" :disabled="!currentNode" @click="handleDelete">删除</el-button>
            </div>
          </div>

          <el-alert
            title="数据治理规则"
            type="info"
            show-icon
            :closable="false"
            description="专业必须挂在学院下，班级必须挂在专业下；例如英语专业只能出现英语1班、英语2班这类班级，不应出现软件工程班级或金融学层级。"
          />

          <el-table :data="flatRows" row-key="deptId" border class="org-table">
            <el-table-column label="名称" prop="deptName" min-width="180" />
            <el-table-column label="类型" width="100">
              <template slot-scope="scope">{{ levelName(scope.row) }}</template>
            </el-table-column>
            <el-table-column label="上级" prop="parentName" min-width="140" />
            <el-table-column label="排序" prop="orderNum" width="80" />
            <el-table-column label="负责人" prop="leader" min-width="120" />
            <el-table-column label="状态" width="90">
              <template slot-scope="scope">
                <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status" />
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
    </el-row>

    <el-dialog :title="dialogTitle" :visible.sync="open" width="560px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="上级节点">
          <el-input :value="parentLabel" disabled />
        </el-form-item>
        <el-form-item label="节点类型">
          <el-input :value="levelName(form)" disabled />
        </el-form-item>
        <el-form-item label="名称" prop="deptName">
          <el-input v-model.trim="form.deptName" maxlength="30" placeholder="请输入名称" />
        </el-form-item>
        <el-form-item label="显示排序" prop="orderNum">
          <el-input-number v-model="form.orderNum" :min="0" controls-position="right" />
        </el-form-item>
        <el-form-item label="负责人">
          <el-input v-model.trim="form.leader" maxlength="20" placeholder="请输入负责人" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model.trim="form.phone" maxlength="11" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model.trim="form.email" maxlength="50" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确定</el-button>
        <el-button @click="open = false">取消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listDept, getDept, addDept, updateDept, delDept } from "@/api/system/dept"

const TEACHING_ROOT_ID = 120

export default {
  name: "OrgManage",
  dicts: ["sys_normal_disable"],
  data() {
    return {
      loading: false,
      filterText: "",
      treeData: [],
      flatRows: [],
      currentNode: null,
      open: false,
      dialogTitle: "",
      form: {},
      treeProps: {
        children: "children",
        label: "deptName"
      },
      rules: {
        deptName: [{ required: true, message: "名称不能为空", trigger: "blur" }],
        orderNum: [{ required: true, message: "排序不能为空", trigger: "blur" }]
      }
    }
  },
  computed: {
    canAddChild() {
      return this.currentNode && this.getLevel(this.currentNode) < 3
    },
    parentLabel() {
      if (!this.form.parentId || this.form.parentId === TEACHING_ROOT_ID) {
        return "教学组织"
      }
      const parent = this.flatRows.find(item => item.deptId === this.form.parentId)
      return parent ? parent.deptName : "-"
    }
  },
  watch: {
    filterText(value) {
      this.$refs.orgTree && this.$refs.orgTree.filter(value)
    }
  },
  created() {
    this.getTree()
  },
  methods: {
    getTree() {
      this.loading = true
      listDept({ status: "0" }).then(res => {
        const rows = res.data || []
        const teachingRoot = rows.find(item => item.deptId === TEACHING_ROOT_ID)
        const children = rows.filter(item => this.belongsToTeaching(item))
        this.treeData = this.buildTree(children, teachingRoot ? teachingRoot.deptId : TEACHING_ROOT_ID)
        this.flatRows = children
      }).finally(() => {
        this.loading = false
      })
    },
    belongsToTeaching(row) {
      return row.parentId === TEACHING_ROOT_ID || String(row.ancestors || "").split(",").includes(String(TEACHING_ROOT_ID))
    },
    buildTree(rows, parentId) {
      return rows
        .filter(item => item.parentId === parentId)
        .sort((a, b) => (a.orderNum || 0) - (b.orderNum || 0))
        .map(item => ({ ...item, children: this.buildTree(rows, item.deptId) }))
    },
    filterNode(value, data) {
      if (!value) {
        return true
      }
      return data.deptName && data.deptName.indexOf(value) !== -1
    },
    handleNodeClick(data) {
      this.currentNode = data
    },
    getLevel(row) {
      if (!row || row.parentId === TEACHING_ROOT_ID) {
        return 1
      }
      const parent = this.flatRows.find(item => item.deptId === row.parentId)
      return parent ? this.getLevel(parent) + 1 : 1
    },
    levelName(row) {
      const level = this.getLevel(row)
      return ["", "学院", "专业", "班级"][level] || "非法层级"
    },
    resetFormModel(parentId) {
      this.form = {
        deptId: undefined,
        parentId,
        deptName: "",
        orderNum: 0,
        leader: "",
        phone: "",
        email: "",
        status: "0"
      }
      this.$nextTick(() => this.resetForm("form"))
    },
    handleAddRoot() {
      this.dialogTitle = "新增学院"
      this.resetFormModel(TEACHING_ROOT_ID)
      this.open = true
    },
    handleAddChild() {
      if (!this.canAddChild) {
        return
      }
      this.dialogTitle = `新增${this.getLevel(this.currentNode) === 1 ? "专业" : "班级"}`
      this.resetFormModel(this.currentNode.deptId)
      this.open = true
    },
    handleEdit() {
      getDept(this.currentNode.deptId).then(res => {
        this.form = res.data
        this.dialogTitle = `编辑${this.levelName(this.currentNode)}`
        this.open = true
      })
    },
    handleDelete() {
      this.$modal.confirm(`确认删除“${this.currentNode.deptName}”吗？`).then(() => {
        return delDept(this.currentNode.deptId)
      }).then(() => {
        this.$modal.msgSuccess("删除成功")
        this.currentNode = null
        this.getTree()
      }).catch(() => {})
    },
    validateBusinessRule() {
      const parent = this.flatRows.find(item => item.deptId === this.form.parentId)
      const level = this.form.parentId === TEACHING_ROOT_ID ? 1 : this.getLevel(parent) + 1
      const name = this.form.deptName || ""
      if (level > 3) {
        this.$modal.msgError("班级下不能再创建层级")
        return false
      }
      if (level === 3) {
        if (parent && parent.deptName && !name.startsWith(parent.deptName)) {
          this.$modal.msgError("班级名称应以所属专业名称开头，例如“英语1班”")
          return false
        }
      }
      return true
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid || !this.validateBusinessRule()) {
          return
        }
        const request = this.form.deptId ? updateDept(this.form) : addDept(this.form)
        request.then(() => {
          this.$modal.msgSuccess("保存成功")
          this.open = false
          this.getTree()
        })
      })
    }
  }
}
</script>

<style scoped lang="scss">
.org-tree-panel,
.org-main {
  border: 1px solid #e5eaf3;
  border-radius: 6px;
  background: #fff;
  padding: 14px;
}

.panel-title,
.org-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.org-toolbar {
  margin-bottom: 14px;
}

.org-toolbar h3 {
  margin: 0 0 4px;
  font-size: 16px;
}

.org-toolbar p {
  margin: 0;
  color: #909399;
  font-size: 12px;
}

.toolbar-actions {
  white-space: nowrap;
}

.org-tree {
  margin-top: 12px;
}

.org-node {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.org-table {
  margin-top: 14px;
}
</style>
