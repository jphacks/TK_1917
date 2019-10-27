import axios from "axios";
async function main() {
  try {
    // const resp = await axios.get('http://localhost:3000/slack-config')

    const resp = await axios.get(
      "https://qolab-api.herokuapp.com/slack-config",
    );
    resp.data.forEach(slackConf => {
      axios.post(slackConf.url, {
        text:
          "昨日一日の活動を振り返ってみよう！\nhttps://qolab-a0324.firebaseapp.com",
        channel: slackConf.channel,
      });
    });
  } catch (e) {
    console.debug(e);
  }
}
main();
