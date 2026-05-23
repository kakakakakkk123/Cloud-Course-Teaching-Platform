<template>
  <div class="student-archive">
    <div class="student-archive__intro">
      <h3>学习档案</h3>
      <p>记录你的学习目标、过程与沉淀内容，让个人中心真正成为长期可追踪的学习空间。</p>
    </div>

    <el-form ref="form" :model="form" :rules="rules" label-width="96px" class="archive-form">
      <div class="archive-grid">
        <el-form-item label="待办事项" prop="todoItems" class="archive-grid__full">
          <div class="todo-panel">
            <div class="todo-input-row">
              <el-input
                v-model.trim="todoDraft"
                placeholder="输入一条新的待办事项，比如：完成数据库作业"
                @keyup.enter.native="addTodoItem"
              />
              <el-button type="primary" icon="el-icon-plus" @click="addTodoItem">添加</el-button>
            </div>

            <div v-if="todoList.length" class="todo-list">
              <div
                v-for="item in todoList"
                :key="item.id"
                class="todo-item"
                :class="{ 'is-done': item.done }"
              >
                <div class="todo-item__main">
                  <span class="todo-item__text">{{ item.text }}</span>
                  <span class="todo-item__status">{{ item.done ? '已完成' : '进行中' }}</span>
                </div>
                <div class="todo-item__actions">
                  <el-button
                    v-if="!item.done"
                    size="mini"
                    type="success"
                    plain
                    @click="markTodoDone(item.id)"
                  >
                    完成
                  </el-button>
                  <el-button
                    v-else
                    size="mini"
                    type="info"
                    plain
                    @click="markTodoUndone(item.id)"
                  >
                    取消完成
                  </el-button>
                  <el-button size="mini" type="danger" plain @click="removeTodoItem(item.id)">
                    删除
                  </el-button>
                </div>
              </div>
            </div>

            <div v-else class="todo-empty">
              还没有待办事项，先添加一条今天要完成的学习任务吧。
            </div>
          </div>
        </el-form-item>

        <el-form-item label="学习历史" prop="learningHistory">
          <el-input
            v-model="form.learningHistory"
            type="textarea"
            :rows="5"
            placeholder="记录本周完成的课程、练习、项目或复盘内容"
          />
        </el-form-item>

        <el-form-item label="学习笔记" prop="learningNotes">
          <el-input
            v-model="form.learningNotes"
            type="textarea"
            :rows="5"
            placeholder="沉淀课程重点、实验结论、知识点摘要"
          />
        </el-form-item>

        <el-form-item label="我的收藏" prop="favorites">
          <el-input
            v-model="form.favorites"
            type="textarea"
            :rows="5"
            placeholder="整理优质课程、资料链接、重点资源"
          />
        </el-form-item>

        <el-form-item label="错题整理" prop="wrongQuestions" class="archive-grid__full">
          <div class="wrong-panel">
            <div class="wrong-panel__form">
              <el-input
                v-model.trim="wrongQuestionDraft.title"
                placeholder="输入错题标题，比如：二分查找边界判断"
              />
              <el-input
                v-model="wrongQuestionDraft.problem"
                type="textarea"
                :rows="4"
                placeholder="输入错题内容、题目描述或自己当时出错的原因"
              />
              <el-input
                v-model="wrongQuestionDraft.solution"
                type="textarea"
                :rows="4"
                placeholder="输入解题过程、正确思路或复盘总结"
              />
              <el-button type="primary" icon="el-icon-plus" @click="addWrongQuestion">添加错题</el-button>
            </div>

            <div v-if="wrongQuestionList.length" class="wrong-list">
              <div v-for="item in wrongQuestionList" :key="item.id" class="wrong-item">
                <div class="wrong-item__header">
                  <strong>{{ item.title }}</strong>
                  <el-button size="mini" type="danger" plain @click="removeWrongQuestion(item.id)">
                    删除
                  </el-button>
                </div>
                <div class="wrong-item__block">
                  <span class="wrong-item__label">错题内容</span>
                  <p>{{ item.problem }}</p>
                </div>
                <div class="wrong-item__block">
                  <span class="wrong-item__label">解题过程</span>
                  <p>{{ item.solution }}</p>
                </div>
              </div>
            </div>

            <div v-else class="todo-empty">
              还没有整理错题，添加后可以把题目和解题过程一起沉淀下来。
            </div>
          </div>
        </el-form-item>

        <el-form-item label="交流讨论" prop="discussions">
          <el-input
            v-model="form.discussions"
            type="textarea"
            :rows="5"
            placeholder="记录课堂发言、小组协作、讨论主题与结论"
          />
        </el-form-item>
      </div>

      <div class="archive-actions">
        <el-button type="primary" @click="submit">保存档案</el-button>
      </div>
    </el-form>
  </div>
</template>

<script>
import { getStudentProfile, updateStudentProfile } from "@/api/system/user"

export default {
  data() {
    return {
      form: {},
      rules: {},
      todoDraft: "",
      todoList: [],
      wrongQuestionList: [],
      wrongQuestionDraft: {
        title: "",
        problem: "",
        solution: ""
      }
    }
  },
  created() {
    this.load()
  },
  methods: {
    load() {
      getStudentProfile().then(res => {
        this.form = res.data || {}
        this.todoList = this.parseTodoItems(this.form.todoItems)
        this.wrongQuestionList = this.parseWrongQuestions(this.form.wrongQuestions)
      })
    },
    parseTodoItems(rawValue) {
      if (!rawValue) return []
      try {
        const parsed = JSON.parse(rawValue)
        if (Array.isArray(parsed)) {
          return parsed
            .map((item, index) => {
              if (typeof item === "string") {
                return { id: `legacy-${index}`, text: item.trim(), done: false }
              }
              return {
                id: item.id || `todo-${index}`,
                text: (item.text || "").trim(),
                done: Boolean(item.done)
              }
            })
            .filter(item => item.text)
        }
      } catch (e) {
        return rawValue
          .split(/\r?\n/)
          .map((text, index) => ({
            id: `legacy-line-${index}`,
            text: text.trim(),
            done: false
          }))
          .filter(item => item.text)
      }
      return []
    },
    syncTodoItems() {
      this.form.todoItems = JSON.stringify(this.todoList)
    },
    parseWrongQuestions(rawValue) {
      if (!rawValue) return []
      try {
        const parsed = JSON.parse(rawValue)
        if (Array.isArray(parsed)) {
          return parsed
            .map((item, index) => {
              if (typeof item === "string") {
                return {
                  id: `legacy-wrong-${index}`,
                  title: `错题 ${index + 1}`,
                  problem: item.trim(),
                  solution: ""
                }
              }
              return {
                id: item.id || `wrong-${index}`,
                title: (item.title || `错题 ${index + 1}`).trim(),
                problem: (item.problem || "").trim(),
                solution: (item.solution || "").trim()
              }
            })
            .filter(item => item.problem || item.solution)
        }
      } catch (e) {
        return [{
          id: "legacy-wrong-text",
          title: "历史错题记录",
          problem: rawValue.trim(),
          solution: ""
        }].filter(item => item.problem)
      }
      return []
    },
    syncWrongQuestions() {
      this.form.wrongQuestions = JSON.stringify(this.wrongQuestionList)
    },
    addTodoItem() {
      if (!this.todoDraft) {
        this.$modal.msgWarning("请先输入待办事项内容")
        return
      }
      this.todoList.unshift({
        id: `todo-${Date.now()}`,
        text: this.todoDraft,
        done: false
      })
      this.todoDraft = ""
      this.syncTodoItems()
    },
    markTodoDone(id) {
      this.todoList = this.todoList.map(item =>
        item.id === id ? { ...item, done: true } : item
      )
      this.syncTodoItems()
    },
    markTodoUndone(id) {
      this.todoList = this.todoList.map(item =>
        item.id === id ? { ...item, done: false } : item
      )
      this.syncTodoItems()
    },
    removeTodoItem(id) {
      this.todoList = this.todoList.filter(item => item.id !== id)
      this.syncTodoItems()
    },
    addWrongQuestion() {
      if (!this.wrongQuestionDraft.problem || !this.wrongQuestionDraft.solution) {
        this.$modal.msgWarning("请填写错题内容和解题过程")
        return
      }
      this.wrongQuestionList.unshift({
        id: `wrong-${Date.now()}`,
        title: this.wrongQuestionDraft.title || `错题 ${this.wrongQuestionList.length + 1}`,
        problem: this.wrongQuestionDraft.problem,
        solution: this.wrongQuestionDraft.solution
      })
      this.wrongQuestionDraft = {
        title: "",
        problem: "",
        solution: ""
      }
      this.syncWrongQuestions()
    },
    removeWrongQuestion(id) {
      this.wrongQuestionList = this.wrongQuestionList.filter(item => item.id !== id)
      this.syncWrongQuestions()
    },
    submit() {
      this.syncTodoItems()
      this.syncWrongQuestions()
      updateStudentProfile(this.form).then(() => {
        this.$modal.msgSuccess("学习档案已保存")
      })
    }
  }
}
</script>

<style scoped lang="scss">
.student-archive__intro {
  margin-bottom: 18px;
}

.student-archive__intro h3 {
  margin: 0;
  color: #173766;
  font-size: 22px;
}

.student-archive__intro p {
  margin: 8px 0 0;
  color: #73819a;
  line-height: 1.7;
}

.archive-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 0 16px;
}

.archive-grid__full {
  grid-column: 1 / -1;
}

.todo-panel {
  padding: 16px;
  border: 1px solid #d9e1ee;
  border-radius: 16px;
  background: #fbfcfe;
}

.todo-input-row {
  display: flex;
  gap: 12px;
  align-items: center;
}

.todo-input-row .el-input {
  flex: 1;
}

.todo-list {
  margin-top: 14px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.todo-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 14px;
  background: #fff;
  border: 1px solid #e6ebf5;
}

.todo-item.is-done {
  background: #f5f9f6;
  border-color: #cfe5d4;
}

.todo-item__main {
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.todo-item__text {
  color: #20324d;
  line-height: 1.6;
  word-break: break-word;
}

.todo-item.is-done .todo-item__text {
  color: #7f8a9c;
  text-decoration: line-through;
}

.todo-item__status {
  font-size: 12px;
  color: #7a8aa0;
}

.todo-item__actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.todo-empty {
  margin-top: 14px;
  padding: 18px 14px;
  text-align: center;
  color: #8a94a6;
  background: #fff;
  border: 1px dashed #d8e0ec;
  border-radius: 14px;
}

.wrong-panel {
  padding: 16px;
  border: 1px solid #d9e1ee;
  border-radius: 16px;
  background: #fbfcfe;
}

.wrong-panel__form {
  display: grid;
  gap: 12px;
}

.wrong-list {
  margin-top: 14px;
  display: grid;
  gap: 12px;
}

.wrong-item {
  padding: 16px;
  border-radius: 14px;
  background: #fff;
  border: 1px solid #e6ebf5;
}

.wrong-item__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 12px;
}

.wrong-item__header strong {
  color: #173766;
  font-size: 16px;
}

.wrong-item__block + .wrong-item__block {
  margin-top: 10px;
}

.wrong-item__label {
  display: inline-block;
  margin-bottom: 6px;
  color: #6d7b92;
  font-size: 12px;
  font-weight: 600;
}

.wrong-item__block p {
  margin: 0;
  color: #20324d;
  line-height: 1.7;
  white-space: pre-wrap;
  word-break: break-word;
}

.archive-form ::v-deep .el-input__inner,
.archive-form ::v-deep .el-textarea__inner {
  border-radius: 14px;
  border-color: #d9e1ee;
  background: #fbfcfe;
}

.archive-form ::v-deep .el-textarea__inner {
  min-height: 132px !important;
  line-height: 1.7;
}

.archive-actions {
  margin-top: 12px;
}

@media (max-width: 768px) {
  .archive-grid {
    grid-template-columns: 1fr;
  }

  .archive-grid__full {
    grid-column: auto;
  }

  .todo-input-row,
  .todo-item,
  .todo-item__actions,
  .wrong-item__header {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
