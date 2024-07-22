// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap

import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbo:load", function () {
  if (document.getElementById("myModal")) {
    const prompts = [
      {
        en: "What did you have for dinner today?",
        ja: "今日の夜ご飯は何を食べましたか？",
      },
      {
        en: "What is something new you learned today?",
        ja: "今日新しく学んだことは何ですか?",
      },
      {
        en: "What was the first thing you did after you woke up this morning?",
        ja: "今日朝起きてから一番初めにしたことはなんですか？",
      },
      {
        en: "What are you looking forward to tomorrow?",
        ja: "明日の楽しみはなんですか？",
      },
      {
        en: "What did you work hard on today?",
        ja: "今日頑張ったことはなんですか？",
      },
      {
        en: "Where did you go today?",
        ja: "今日はどこにいきましたか？",
      },
      {
        en: "What new thing did you learn today?",
        ja: "今日学んだ新しいことはなんですか？",
      },
      {
        en: "What did you try today?",
        ja: "今日挑戦したことはなんですか？",
      },
      {
        en: "What do you have to do tomorrow?",
        ja: "明日やらなければいけないことはなんですか？",
      },
      {
        en: "What was good about today?",
        ja: "今日良かったことはなんですか？",
      },
      {
        en: "What didn't go well today?",
        ja: "今日良くなかったことはなんですか？",
      },
      {
        en: "What news did you see today?",
        ja: "今日見たニュースはなんですか？",
      },
      {
        en: "What is the most memorable event of today?",
        ja: "今日の最も心に残っている出来事はなんですか？",
      },
      {
        en: "What new English words did you learn today?",
        ja: "今日新しく学んだ英単語はなんですか？",
      },
      {
        en: "What do you have for breakfast today?",
        ja: "今日の朝ごはんはなんですか？",
      },
      {
        en: "How is the weather today?",
        ja: "今日の天気はどうですか？",
      },
      {
        en: "Please tell me your dreams for the future.",
        ja: "将来の夢を教えて下さい",
      },
    ];

    let diaryEntry = "";
    let responses = 0;

    const modal = $("#myModal");
    const questionElement = document.getElementById("randomQuestion");
    const translatedQuestionElement =
      document.getElementById("translatedQuestion");
    const inputElement = document.getElementById("answerInput");

    function setRandomQuestion() {
      const randomIndex = Math.floor(Math.random() * prompts.length);
      const randomQuestion = prompts[randomIndex];
      questionElement.innerText = randomQuestion.en;
      translatedQuestionElement.innerText = randomQuestion.ja; // 日本語の質問を保持
      translatedQuestionElement.style.display = "none"; // 最初は非表示
    }

    async function generateQuestionFromServer(previousResponse) {
      const response = await fetch(
        `/question/generate_question?prompt=${encodeURIComponent(
          previousResponse
        )}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        }
      );
      const data = await response.json();
      questionElement.innerText = data.en;
      document.getElementById("translatedQuestion").innerText = data.ja;
    }

    // モーダル表示時に質問をセット
    modal.on("show.bs.modal", function (e) {
      setRandomQuestion();
      inputElement.value = ""; // 入力フィールドをクリア
    });

    // xボタン
    document.getElementById("close").addEventListener("click", function () {
      diaryEntry = "";
      responses = 0;
    });

    // 翻訳ボタン
    document
      .getElementById("translateQuestion")
      .addEventListener("click", function () {
        document.getElementById("translatedQuestion").style.display = "block";
      });

    // 別の質問ボタン
    document
      .getElementById("changeQuestion")
      .addEventListener("click", function () {
        setRandomQuestion();
        inputElement.value = "";
        document.getElementById("translatedQuestion").style.display = "none";
      });

    // 次へボタン
    document
      .getElementById("nextQuestion")
      .addEventListener("click", function () {
        const userInput = inputElement.value.trim();
        document.getElementById("translatedQuestion").style.display = "none";
        if (userInput !== "") {
          diaryEntry += userInput + "\n";
          responses++;
          inputElement.value = ""; // 入力フィールドをクリア

          if (responses >= 1) {
            generateQuestionFromServer(diaryEntry);
            document.getElementById("changeQuestion").style.display = "none";
          } else {
            setRandomQuestion();
          }

          if (responses >= 3) {
            document.querySelector("#diary_title").value =
              "Interactive diary entries: " + new Date().toLocaleDateString();
            document.querySelector("#diary_content").value = diaryEntry;
            modal.modal("hide");
            diaryEntry = "";
            responses = 0;
          }
        }
      });
  }
});
