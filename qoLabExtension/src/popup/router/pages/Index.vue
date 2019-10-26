<template>
  <div>
    <h2>ログイン</h2>
    <form>
      <label for="email">Email</label>
      <input type="email" name="email" />
      <label for="password">Password</label>
      <input type="password" name="password" />
      <input type="submit" v-on:click="login" />
    </form>
  </div>
</template>

<script>
import router from 'vue-router';
export default {
  data() {
    return {};
  },
  methods: {
    login: function() {
      this.$router.push('/home');
    },
  },
};
</script>

<style lang="scss" scoped></style>
