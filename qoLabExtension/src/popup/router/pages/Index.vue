<template>
  <div>
    <h2>Home</h2>
    <div @click="clear">clear</div>
  </div>
</template>

<script>
import router from 'vue-router';
import api, { createApiClientWithAuthHeader } from '../../utils/apiClient';

export default {
  data() {
    return {};
  },
  mounted() {
    chrome.storage.sync.get(['access_token'], this.checkToken);
  },
  methods: {
    checkToken: async function(result) {
      if (!result.access_token) {
        chrome.storage.sync.clear();
        this.$router.push('/signin');
        return;
      }

      try {
        const apiWithAuthHeader = createApiClientWithAuthHeader(result.access_token);
        await apiWithAuthHeader.get('/me');
      } catch {
        chrome.storage.sync.clear();
        this.$router.push('/signin');
      }
    },
    clear: function() {
      chrome.storage.sync.clear();
      location.reload();
    },
  },
};
</script>

<style lang="scss" scoped></style>
