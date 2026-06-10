<template>
  <div class="app-container account-page" :class="{ 'has-tree': showOrgFilter }">
    <tree-panel
      v-if="showOrgFilter"
      ref="accountTreeRef"
      title="院系分类"
      :tree-data="deptTreeOptions"
      search-placeholder="请输入学院 / 专业 / 班级"
      storage-key="account-dept-sidebar-width"
      :defaultExpandAll="true"
      @node-click="handleTreeNodeClick"
      @refresh="resetTreeFilter"
    >
      <template #node="{ data }">
        <span class="account-tree-node">
          <i :class="data.children && data.children.length ? 'el-icon-folder-opened' : 'el-icon-document'" class="node-icon" />
          <span class="node-label" :title="data.label">{{ data.label }}</span>
          <span v-if="data.levelLabel" class="node-level-tag">{{ data.levelLabel }}</span>
        </span>
      </template>
    </tree-panel>

    <div class="account-content">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="72px">
        <el-form-item label="登录账号" prop="userName">
          <el-input v-model="queryParams.userName" placeholder="请输入登录账号" clearable style="width: 220px" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="手机号" prop="phonenumber">
          <el-input v-model="queryParams.phonenumber" placeholder="请输入手机号" clearable style="width: 220px" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="账号状态" clearable style="width: 180px">
            <el-option v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="创建时间">
          <el-date-picker
            v-model="dateRange"
            style="width: 240px"
            value-format="yyyy-MM-dd"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>

      <el-row :gutter="10" class="mb8">
        <el-col v-if="canManageAccounts" :span="1.5">
          <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
        </el-col>
        <el-col v-if="canManageAccounts" :span="1.5">
          <el-button type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
        </el-col>
        <el-col v-if="canManageStudents" :span="1.5">
          <el-button type="success" plain icon="el-icon-video-play" size="mini" :disabled="multiple" @click="handleBatchStatusChange('0')">批量启用</el-button>
        </el-col>
        <el-col v-if="canManageStudents" :span="1.5">
          <el-button type="warning" plain icon="el-icon-video-pause" size="mini" :disabled="multiple" @click="handleBatchStatusChange('1')">批量禁用</el-button>
        </el-col>
        <el-col v-if="canManageStudents" :span="1.5">
          <el-button type="primary" plain icon="el-icon-key" size="mini" :disabled="multiple" @click="handleBatchResetPwd">批量重置密码</el-button>
        </el-col>
        <el-col v-if="canManageStudents" :span="1.5">
          <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">批量删除</el-button>
        </el-col>
        <el-col v-if="canManageAccounts" :span="1.5">
          <el-button type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport">导入</el-button>
        </el-col>
        <el-col v-if="canManageAccounts" :span="1.5">
          <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
      </el-row>

      <el-table ref="userTable" v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="50" align="center" :selectable="selectableRow" />
        <el-table-column label="用户编号" align="center" prop="userId" width="90" />
        <el-table-column label="登录账号" align="center" min-width="130" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <a class="link-type" @click="handleViewData(scope.row)">{{ scope.row.userName }}</a>
          </template>
        </el-table-column>
        <el-table-column label="用户昵称" align="center" prop="nickName" min-width="120" :show-overflow-tooltip="true" />
        <el-table-column label="身份" align="center" prop="identityName" min-width="110" />
        <el-table-column v-if="showOrgColumns" label="所属学院" align="center" min-width="140" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ getAcademyName(scope.row) }}</template>
        </el-table-column>
        <el-table-column v-if="showOrgColumns" label="年级" align="center" width="100">
          <template slot-scope="scope">{{ getGradeName(scope.row) }}</template>
        </el-table-column>
        <el-table-column v-if="showOrgColumns" label="专业" align="center" min-width="140" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ getMajorName(scope.row) }}</template>
        </el-table-column>
        <el-table-column v-if="showOrgColumns" label="班级" align="center" min-width="140" :show-overflow-tooltip="true">
          <template slot-scope="scope">{{ getClassName(scope.row) }}</template>
        </el-table-column>
        <el-table-column label="手机号" align="center" prop="phonenumber" width="120" />
        <el-table-column label="状态" align="center" width="90">
          <template slot-scope="scope">
            <el-switch
              v-model="scope.row.status"
              active-value="0"
              inactive-value="1"
              :disabled="isAdminAccount(scope.row)"
              @change="handleStatusChange(scope.row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="160">
          <template slot-scope="scope">{{ parseTime(scope.row.createTime) }}</template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="180" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <span v-if="isAdminAccount(scope.row)" class="locked-tip">管理员账号不可操作</span>
            <template v-else>
              <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)">重置密码</el-button>
              <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    <el-dialog :title="title" :visible.sync="open" width="640px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="90px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户昵称" prop="nickName">
              <el-input v-model="form.nickName" placeholder="请输入用户昵称" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col v-if="showOrgColumns" :span="12">
            <el-form-item label="所属院系" prop="deptId">
              <treeselect v-model="form.deptId" :options="enabledDeptOptions" :show-count="true" placeholder="请选择学院 / 专业 / 班级" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phonenumber">
              <el-input v-model="form.phonenumber" placeholder="请输入手机号" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="form.email" placeholder="请输入邮箱" maxlength="50" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item v-if="form.userId === undefined" label="登录账号" prop="userName">
              <el-input v-model="form.userName" placeholder="请输入登录账号" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item v-if="form.userId === undefined" label="登录密码" prop="password" :rules="pwdValidator">
              <el-input v-model="form.password" placeholder="请输入登录密码" type="password" maxlength="20" show-password />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户性别">
              <el-select v-model="form.sex" placeholder="请选择性别">
                <el-option v-for="dict in dict.type.sys_user_sex" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户角色">
              <el-select v-model="form.roleIds" multiple placeholder="请选择用户角色">
                <el-option v-for="item in roleOptions" :key="item.roleId" :label="item.roleName" :value="item.roleId" :disabled="item.status === 1" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确定</el-button>
        <el-button @click="cancel">取消</el-button>
      </div>
    </el-dialog>

    <user-view-drawer ref="userViewRef" />
    <excel-import-dialog
      ref="importUserRef"
      title="用户导入"
      action="/system/user/importData"
      template-action="/system/user/importTemplate"
      template-file-name="user_template"
      update-support-label="是否更新已经存在的用户数据"
      @success="getList"
    />
  </div>
</template>

<script>
import { listUser, getUser, delUser, addUser, updateUser, resetUserPwd, changeUserStatus, deptTreeSelect } from "@/api/system/user"
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import TreePanel from "@/components/TreePanel"
import ExcelImportDialog from "@/components/ExcelImportDialog"
import UserViewDrawer from "./view"
import passwordRule from "@/utils/passwordRule"
import { mapGetters } from "vuex"

export default {
  name: "User",
  mixins: [passwordRule],
  dicts: ["sys_normal_disable", "sys_user_sex"],
  components: { Treeselect, TreePanel, ExcelImportDialog, UserViewDrawer },
  computed: {
    ...mapGetters(["roles"]),
    currentRoleId() {
      const routeRoleId = Number(this.$route.query.roleId)
      if (Number.isFinite(routeRoleId) && routeRoleId > 0) {
        return routeRoleId
      }
      const pathRoleMap = {
        "/account/admin": 1,
        "/account/teacher": 3,
        "/account/student": 4
      }
      return pathRoleMap[this.$route.path] || undefined
    },
    showOrgFilter() {
      return this.currentRoleId !== 1
    },
    showOrgColumns() {
      return this.currentRoleId !== 1
    },
    canManageAccounts() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    },
    canManageStudents() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    }
  },
  data() {
    return {
      loading: true,
      ids: [],
      selectedRows: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      userList: [],
      title: "",
      deptTreeOptions: [],
      deptMetaMap: {},
      enabledDeptOptions: [],
      open: false,
      initPassword: undefined,
      dateRange: [],
      postOptions: [],
      roleOptions: [],
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined,
        roleId: undefined
      },
      rules: {
        userName: [
          { required: true, message: "登录账号不能为空", trigger: "blur" },
          { min: 2, max: 20, message: "登录账号长度必须在 2 到 20 个字符之间", trigger: "blur" }
        ],
        nickName: [
          { required: true, message: "用户昵称不能为空", trigger: "blur" }
        ],
        email: [
          { type: "email", message: "请输入正确的邮箱地址", trigger: ["blur", "change"] }
        ],
        phonenumber: [
          { pattern: /^1[3-9]\d{9}$/, message: "请输入正确的手机号", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.applyRouteScope()
    this.getList()
    this.getDeptTree()
    this.getConfigKey("sys.user.initPassword").then(response => {
      this.initPassword = response.msg
    })
  },
  watch: {
    $route() {
      this.applyRouteScope()
      this.handleQuery()
    }
  },
  methods: {
    applyRouteScope() {
      this.queryParams.roleId = this.currentRoleId
      if (!this.showOrgFilter) {
        this.queryParams.deptId = undefined
      }
    },
    getList() {
      this.loading = true
      listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.userList = response.rows || []
        this.total = response.total
        this.loading = false
      })
    },
    getDeptTree() {
      deptTreeSelect().then(response => {
        const data = response.data || []
        this.deptMetaMap = this.buildDeptMetaMap(data)
        this.deptTreeOptions = this.buildDeptFilterTree(data)
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(data)))
      })
    },
    buildDeptMetaMap(nodes, path = []) {
      return (nodes || []).reduce((acc, node) => {
        const label = node.label || ""
        const currentPath = [...path, label]
        acc[node.id] = {
          deptId: node.id,
          label,
          path: currentPath,
          academyName: currentPath[0] || "-",
          majorName: currentPath[1] || "-",
          className: currentPath[2] || "-"
        }
        Object.assign(acc, this.buildDeptMetaMap(node.children || [], currentPath))
        return acc
      }, {})
    },
    buildDeptFilterTree(deptList) {
      return [{
        id: "dept-0",
        deptId: 0,
        label: "全部院系",
        levelLabel: "全部",
        children: this.decorateDeptNodes(JSON.parse(JSON.stringify(deptList || [])))
      }]
    },
    decorateDeptNodes(nodes, level = 0) {
      const levelLabels = ["学院", "专业", "班级"]
      return (nodes || []).map(node => ({
        ...node,
        id: `dept-${node.id}`,
        deptId: node.id,
        levelLabel: levelLabels[level] || "层级",
        children: this.decorateDeptNodes(node.children || [], level + 1)
      }))
    },
    isStudentRow(row) {
      return (row.identityName || "").indexOf("学生") !== -1 || row.roleId === 4
    },
    isTeacherRow(row) {
      return (row.identityName || "").indexOf("教师") !== -1 || row.roleId === 3
    },
    getDeptMeta(row) {
      return this.deptMetaMap[row.deptId] || {}
    },
    getAcademyName(row) {
      if (!this.isTeacherRow(row) && !this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).academyName || "-"
    },
    getMajorName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).majorName || "-"
    },
    getClassName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).className || "-"
    },
    getGradeName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      if (row.grade) {
        return row.grade
      }
      const matchedYear = String(row.studentNo || "").match(/^(20\d{2})/)
      return matchedYear ? `${matchedYear[1]}级` : "-"
    },
    filterDisabledDept(deptList) {
      return deptList.filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    handleTreeNodeClick(data) {
      this.queryParams.deptId = data.deptId > 0 ? data.deptId : undefined
      this.handleQuery()
    },
    resetTreeFilter() {
      this.queryParams.deptId = undefined
      if (this.$refs.accountTreeRef) {
        this.$refs.accountTreeRef.setCurrentKey(null)
      }
      this.handleQuery()
    },
    isAdminAccount(row) {
      const identityName = row.identityName || ""
      return row.userId === 1 || identityName.indexOf("管理员") !== -1 || row.roleId === 1
    },
    selectableRow(row) {
      return !this.isAdminAccount(row)
    },
    getManageRows(rows) {
      return (rows || []).filter(row => !this.isAdminAccount(row))
    },
    handleBatchStatusChange(status) {
      const rows = this.getManageRows(this.selectedRows)
      if (!rows.length) {
        this.$modal.msgWarning("请先选择要操作的账号")
        return
      }
      const actionText = status === "0" ? "启用" : "禁用"
      this.$modal.confirm(`确认要批量${actionText}选中的 ${rows.length} 个账号吗？`).then(() => {
        return Promise.all(rows.map(row => changeUserStatus(row.userId, status)))
      }).then(() => {
        this.$modal.msgSuccess(`批量${actionText}成功`)
        this.getList()
      }).catch(() => {})
    },
    handleBatchResetPwd() {
      const rows = this.getManageRows(this.selectedRows)
      if (!rows.length) {
        this.$modal.msgWarning("请先选择要操作的账号")
        return
      }
      this.$prompt(`请输入所选 ${rows.length} 个账号的新密码`, "批量重置密码", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputValidator: this.pwdPromptValidator
      }).then(({ value }) => {
        return Promise.all(rows.map(row => resetUserPwd(row.userId, value)))
      }).then(() => {
        this.$modal.msgSuccess("批量重置密码成功")
      }).catch(() => {})
    },
    handleStatusChange(row) {
      if (this.isAdminAccount(row)) {
        this.$modal.msgError("管理员账号不能操作")
        row.status = row.status === "0" ? "1" : "0"
        return
      }
      const text = row.status === "0" ? "启用" : "停用"
      this.$modal.confirm(`确认要${text}“${row.userName}”账号吗？`).then(() => {
        return changeUserStatus(row.userId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(`${text}成功`)
      }).catch(() => {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        userId: undefined,
        deptId: undefined,
        userName: undefined,
        nickName: undefined,
        password: undefined,
        phonenumber: undefined,
        email: undefined,
        sex: undefined,
        status: "0",
        remark: undefined,
        roleIds: []
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.applyRouteScope()
      if (this.$refs.accountTreeRef) {
        this.$refs.accountTreeRef.setCurrentKey(null)
      }
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.selectedRows = selection || []
      this.ids = this.selectedRows.map(item => item.userId)
      this.single = this.selectedRows.length !== 1
      this.multiple = !this.selectedRows.length
    },
    handleAdd() {
      this.reset()
      getUser().then(response => {
        this.postOptions = response.posts || []
        this.roleOptions = response.roles || []
        this.open = true
        this.title = "新增账号"
        this.form.password = this.initPassword
      })
    },
    handleUpdate(row) {
      this.reset()
      const userId = row.userId || this.ids
      getUser(userId).then(response => {
        this.form = response.data || {}
        this.postOptions = response.posts || []
        this.roleOptions = response.roles || []
        this.$set(this.form, "roleIds", response.roleIds || [])
        this.open = true
        this.title = "修改账号"
        this.form.password = ""
      })
    },
    handleResetPwd(row) {
      this.$prompt(`请输入“${row.userName}”的新密码`, "重置密码", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputValidator: this.pwdPromptValidator
      }).then(({ value }) => {
        resetUserPwd(row.userId, value).then(() => {
          this.$modal.msgSuccess("修改成功，新密码为：" + value)
        })
      }).catch(() => {})
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        if (!this.showOrgColumns) {
          this.form.deptId = undefined
        }
        if (this.form.userId !== undefined) {
          updateUser(this.form).then(() => {
            this.$modal.msgSuccess("修改成功")
            this.open = false
            this.getList()
          })
        } else {
          addUser(this.form).then(() => {
            this.$modal.msgSuccess("新增成功")
            this.open = false
            this.getList()
          })
        }
      })
    },
    handleDelete(row) {
      const userIds = row.userId ? [row.userId] : this.ids
      const rows = row.userId ? [row] : this.selectedRows
      if (rows.some(item => this.isAdminAccount(item))) {
        this.$modal.msgError("管理员账号不能删除")
        return
      }
      this.$modal.confirm(`是否确认删除账号编号为“${userIds.join("、")}”的数据项？`).then(() => {
        return delUser(userIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleExport() {
      const selectedIds = this.getManageRows(this.selectedRows).map(row => row.userId)
      const exportParams = {
        ...this.queryParams
      }
      if (selectedIds.length) {
        exportParams.userIds = selectedIds.join(",")
      }
      this.download("system/user/export", {
        ...exportParams
      }, `user_${selectedIds.length ? "selected" : "all"}_${new Date().getTime()}.xlsx`)
    },
    handleViewData(row) {
      this.$refs.userViewRef.open(row.userId)
    },
    handleImport() {
      this.$refs.importUserRef.open()
    }
  }
}
</script>

<style scoped lang="scss">
.account-page {
  display: flex;
  min-height: calc(100vh - 84px);
}

.account-page:not(.has-tree) {
  display: block;
}

.account-content {
  flex: 1;
  min-width: 0;
}

.account-tree-node {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}

.node-level-tag {
  padding: 1px 6px;
  border-radius: 10px;
  background: #eef5ff;
  color: #4a7bd0;
  font-size: 12px;
  line-height: 18px;
}

.locked-tip {
  color: #909399;
}

.mb8 {
  margin-bottom: 8px;
}
</style>
