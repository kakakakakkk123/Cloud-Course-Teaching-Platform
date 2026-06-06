<template>
  <div v-if="hasResource" class="course-content-resource">
    <div class="course-content-resource__toolbar">
      <div class="course-content-resource__meta">
        <i :class="resourceIcon"></i>
        <span class="course-content-resource__name" :title="displayName">{{ displayName }}</span>
        <span v-if="canPreviewInline" class="course-content-resource__badge">可预览</span>
      </div>
      <div v-if="showActions" class="course-content-resource__actions">
        <el-button
          v-if="canPreviewInline"
          size="mini"
          plain
          @click="toggleInlinePreview"
        >
          {{ shouldShowInline ? "收起预览" : "站内预览" }}
        </el-button>
        <el-button size="mini" type="primary" plain @click="openResource">
          {{ actionText }}
        </el-button>
      </div>
    </div>

    <div v-if="shouldShowInline" class="course-content-resource__preview">
      <img
        v-if="previewKind === 'image'"
        :src="resourceUrl"
        :alt="displayName"
        class="course-content-resource__image"
      >
      <video
        v-else-if="previewKind === 'video'"
        :src="resourceUrl"
        class="course-content-resource__video"
        controls
        preload="metadata"
      >
        您的浏览器暂不支持视频预览。
      </video>
      <iframe
        v-else-if="previewKind === 'document'"
        :src="resourceUrl"
        class="course-content-resource__frame"
        frameborder="0"
      />
    </div>

    <p v-else-if="showInlineHint" class="course-content-resource__hint">
      当前文件类型暂不支持站内预览，请点击按钮在新窗口中查看。
    </p>
  </div>
</template>

<script>
import { isExternal } from "@/utils/validate"

const IMAGE_EXTENSIONS = ["png", "jpg", "jpeg", "gif", "bmp", "webp", "svg"]
const VIDEO_EXTENSIONS = ["mp4", "webm", "ogg", "mov", "m4v", "avi", "wmv", "flv", "mkv"]
const DOCUMENT_EXTENSIONS = ["pdf", "txt"]

export default {
  name: "CourseContentResource",
  props: {
    item: {
      type: Object,
      default: () => ({})
    },
    showActions: {
      type: Boolean,
      default: true
    },
    autoOpenInline: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      inlineVisible: this.autoOpenInline
    }
  },
  computed: {
    rawUrl() {
      const sourceUrl = this.item.sourceType === "2" ? this.item.linkUrl : this.item.fileUrl
      if (!sourceUrl) {
        return ""
      }
      return String(sourceUrl).split(",")[0].trim()
    },
    resourceUrl() {
      if (!this.rawUrl) {
        return ""
      }
      if (/^(https?:)?\/\//.test(this.rawUrl) || isExternal(this.rawUrl)) {
        return this.rawUrl
      }
      return process.env.VUE_APP_BASE_API + this.rawUrl
    },
    fileExtension() {
      const source = this.displayName || this.rawUrl
      if (!source || source.lastIndexOf(".") === -1) {
        return ""
      }
      return source.slice(source.lastIndexOf(".") + 1).toLowerCase()
    },
    previewKind() {
      if (!this.resourceUrl) {
        return "none"
      }
      if (String(this.item.contentType) === "3" || IMAGE_EXTENSIONS.indexOf(this.fileExtension) > -1) {
        return "image"
      }
      if (String(this.item.contentType) === "2" || VIDEO_EXTENSIONS.indexOf(this.fileExtension) > -1) {
        return "video"
      }
      if (DOCUMENT_EXTENSIONS.indexOf(this.fileExtension) > -1) {
        return "document"
      }
      return "none"
    },
    hasResource() {
      return !!this.resourceUrl
    },
    canPreviewInline() {
      return this.previewKind !== "none"
    },
    shouldShowInline() {
      return this.canPreviewInline && this.inlineVisible
    },
    showInlineHint() {
      return this.hasResource && !this.canPreviewInline
    },
    displayName() {
      if (this.item.fileName) {
        return this.item.fileName
      }
      if (!this.rawUrl) {
        return "资源文件"
      }
      const normalized = this.rawUrl.split("?")[0]
      return normalized.slice(normalized.lastIndexOf("/") + 1) || "资源文件"
    },
    actionText() {
      const map = {
        "1": "打开文档",
        "2": "播放视频",
        "3": "查看图片",
        "4": "打开链接",
        "5": "打开资源"
      }
      return map[String(this.item.contentType)] || "打开资源"
    },
    resourceIcon() {
      const map = {
        image: "el-icon-picture-outline",
        video: "el-icon-video-camera",
        document: "el-icon-document"
      }
      return map[this.previewKind] || "el-icon-paperclip"
    }
  },
  methods: {
    toggleInlinePreview() {
      this.inlineVisible = !this.shouldShowInline
    },
    openResource() {
      if (!this.resourceUrl) {
        return
      }
      window.open(this.resourceUrl, "_blank")
    }
  }
}
</script>

<style lang="scss" scoped>
.course-content-resource {
  margin-top: 12px;
  padding: 14px;
  border: 1px solid rgba(148, 163, 184, 0.18);
  border-radius: 14px;
  background: #fff;
}

.course-content-resource__toolbar,
.course-content-resource__meta,
.course-content-resource__actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.course-content-resource__toolbar {
  justify-content: space-between;
  flex-wrap: wrap;
}

.course-content-resource__meta {
  min-width: 0;
  color: #334155;
}

.course-content-resource__name {
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.course-content-resource__badge {
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(37, 99, 235, 0.12);
  color: #2563eb;
  font-size: 12px;
}

.course-content-resource__preview {
  margin-top: 14px;
}

.course-content-resource__image,
.course-content-resource__video,
.course-content-resource__frame {
  width: 100%;
  border-radius: 12px;
  background: #0f172a;
}

.course-content-resource__image {
  display: block;
  max-height: 420px;
  object-fit: contain;
  background: #f8fafc;
}

.course-content-resource__video {
  max-height: 420px;
}

.course-content-resource__frame {
  min-height: 420px;
  background: #fff;
}

.course-content-resource__hint {
  margin: 12px 0 0;
  color: #64748b;
  font-size: 13px;
  line-height: 1.7;
}
</style>
