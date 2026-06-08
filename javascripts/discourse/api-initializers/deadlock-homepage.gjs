import { on } from "@ember/modifier";
import { themePrefix } from "virtual:theme";
import { apiInitializer } from "discourse/lib/api";
import { i18n } from "discourse-i18n";

const HOME = {
  imageBase:
    "https://cdn.fastly.steamstatic.com/apps/deadlock/images/react/oldgods/",
  playersOnline: "53,802",
  patchNotes: {
    title: "05-22-2026 update",
    excerpt:
      "Read the latest Deadlock patch notes and discuss the current build.",
    url: "/t/05-22-2026-update/9",
    image: "ui_scoreboard.png",
  },
  categories: [
    {
      title: "Bug reports",
      description:
        "File gameplay issues, UI problems, and reproducible crashes.",
      url: "/c/bug-reports/6",
      image: "ui_recording.png",
    },
    {
      title: "Known issues",
      description: "Track reports that need extra confirmation or test cases.",
      url: "/c/bug-reports/6",
      image: "settings_search.png",
    },
  ],
  chatChannels: [
    {
      title: "General chat",
      description: "Talk Deadlock, ask questions, and find people online now.",
      url: "/chat/c/general/2",
      image: "top_bar.png",
    },
    {
      title: "Match watch party",
      description: "Follow streams, Night Shift games, and community events.",
      url: "/chat/c/general/2",
      image: "postgame_scorecard.png",
    },
  ],
  voiceChannel: {
    title: "Watercooler voice",
    description:
      "Join the Resenha voice room for live team-up and watch-party calls.",
    url: "#deadlock-voice",
    slug: "watercooler",
    image: "ui_random.png",
  },
  matches: [
    {
      title: "Abrahams vs. Lowkey W",
      meta: "Night Shift #41 EU semifinal, Bo1, June 3, 2026, 15:00 EST",
      url: "https://liquipedia.net/deadlock/Deadlock_Night_Shift/41/EU",
    },
    {
      title: "Leviathan vs. Lowkey W",
      meta: "Night Shift #41 EU grand final, Bo3, June 3, 2026, 16:00 EST",
      url: "https://liquipedia.net/deadlock/Deadlock_Night_Shift/41/EU",
    },
    {
      title: "Lowkey W 2-0 Leviathan",
      meta: "Grand final result, games lasted 29:19 and 29:17",
      url: "https://liquipedia.net/deadlock/Deadlock_Night_Shift/41/EU",
    },
  ],
  news: [
    {
      title:
        "Don't let Deadlock's MOBA tag scare you off - there's a quick play mode for dummies which is the perfect entry point",
      meta: "PC Gamer via Steam News",
      url: "https://steamstore-a.akamaihd.net/news/externalpost/PC%20Gamer/1834602721198635",
    },
    {
      title:
        "Valve just reworked Deadlock's Soul Urn yet again, and even the item itself is ready to give up",
      meta: "PCGamesN via Steam News",
      url: "https://steamstore-a.akamaihd.net/news/externalpost/PCGamesN/1834602721190391",
    },
    {
      title: "Minor Update - 06-04-2026",
      meta: "Community Announcements via Steam News",
      url: "https://steamstore-a.akamaihd.net/news/externalpost/steam_community_announcements/1834602721188293",
    },
  ],
  ranking: [
    { rank: 1, flag: "🇳🇱", player: "cosmetical", mmr: "12,840" },
    { rank: 2, flag: "🇷🇺", player: "Tas", mmr: "12,695" },
    { rank: 3, flag: "🇷🇺", player: "saintmxsm", mmr: "12,604" },
    { rank: 4, flag: "🇬🇧", player: "Zerggy", mmr: "12,511" },
    { rank: 5, flag: "🏴", player: "lystic", mmr: "12,448" },
    { rank: 6, flag: "🇸🇪", player: "Hoot", mmr: "12,380" },
    { rank: 7, flag: "🇩🇪", player: "vraic", mmr: "12,322" },
    { rank: 8, flag: "🇺🇦", player: "freemok", mmr: "12,210" },
    { rank: 9, flag: "🇧🇾", player: "oses", mmr: "12,168" },
    { rank: 10, flag: "🇷🇺", player: "obikym", mmr: "12,101" },
  ],
};

export default apiInitializer((api) => {
  const showLogin = () => {
    api.container.lookup("route:application").send("showLogin");
  };

  const requireLogin = (event) => {
    if (api.getCurrentUser()) {
      return false;
    }

    event.preventDefault();
    event.stopPropagation();
    showLogin();
    return true;
  };

  const joinVoiceRoom = async (event) => {
    if (requireLogin(event)) {
      return;
    }

    event.preventDefault();

    try {
      const roomsService = api.container.lookup("service:resenha-rooms");
      const resenhaWebrtc = api.container.lookup("service:resenha-webrtc");

      await roomsService.ready;

      const room =
        roomsService.roomBySlug?.(HOME.voiceChannel.slug) ||
        roomsService.rooms?.[0];

      if (room) {
        await resenhaWebrtc.join(room);
      }
    } catch {
      // Resenha is optional for this demo theme.
    }
  };

  api.registerBehaviorTransformer("custom-homepage-model", () => HOME);

  api.renderInOutlet(
    "custom-homepage",
    <template>
      <div class="deadlock-home">
        <section class="deadlock-home__hero">
          <div class="deadlock-home__hero-copy">
            <p class="deadlock-home__eyebrow">
              {{i18n (themePrefix "deadlock_home.eyebrow")}}
            </p>
            <h1 class="deadlock-home__title">
              {{i18n (themePrefix "deadlock_home.title")}}
            </h1>
            <p class="deadlock-home__intro">
              {{i18n (themePrefix "deadlock_home.intro")}}
            </p>
          </div>

          <div
            class="deadlock-home__counter"
            aria-label={{i18n
              (themePrefix "deadlock_home.players_online_aria")
              count=@outletArgs.model.playersOnline
            }}
          >
            <span class="deadlock-home__counter-value">
              {{@outletArgs.model.playersOnline}}
            </span>
            <span class="deadlock-home__counter-label">
              {{i18n (themePrefix "deadlock_home.players_online")}}
            </span>
          </div>
        </section>

        <section class="deadlock-home__panel --patch">
          <div class="deadlock-home__section-heading">
            <p class="deadlock-home__eyebrow">
              {{i18n (themePrefix "deadlock_home.patch_eyebrow")}}
            </p>
            <h2>{{i18n (themePrefix "deadlock_home.patch_title")}}</h2>
          </div>

          <a
            class="deadlock-home__feature-link"
            href={{@outletArgs.model.patchNotes.url}}
          >
            <img
              class="deadlock-home__card-image"
              src="{{@outletArgs.model.imageBase}}{{@outletArgs.model.patchNotes.image}}"
              alt=""
            />
            <span class="deadlock-home__card-content">
              <span class="deadlock-home__feature-title">
                {{@outletArgs.model.patchNotes.title}}
              </span>
              <span class="deadlock-home__feature-copy">
                {{@outletArgs.model.patchNotes.excerpt}}
              </span>
            </span>
          </a>
        </section>

        <section class="deadlock-home__section">
          <div class="deadlock-home__section-heading">
            <p class="deadlock-home__eyebrow">
              {{i18n (themePrefix "deadlock_home.forum_eyebrow")}}
            </p>
            <h2>{{i18n (themePrefix "deadlock_home.forum_title")}}</h2>
          </div>

          <div class="deadlock-home__cards --categories">
            {{#each @outletArgs.model.categories as |category|}}
              <a class="deadlock-home__card" href={{category.url}}>
                <img
                  class="deadlock-home__card-image"
                  src="{{@outletArgs.model.imageBase}}{{category.image}}"
                  alt=""
                />
                <span class="deadlock-home__card-content">
                  <span
                    class="deadlock-home__card-title"
                  >{{category.title}}</span>
                  <span class="deadlock-home__card-copy">
                    {{category.description}}
                  </span>
                </span>
              </a>
            {{/each}}
          </div>
        </section>

        <section class="deadlock-home__section">
          <div class="deadlock-home__section-heading">
            <p class="deadlock-home__eyebrow">
              {{i18n (themePrefix "deadlock_home.chat_eyebrow")}}
            </p>
            <h2>{{i18n (themePrefix "deadlock_home.chat_title")}}</h2>
          </div>

          <div class="deadlock-home__cards --chat">
            {{#each @outletArgs.model.chatChannels as |channel|}}
              <a
                class="deadlock-home__card"
                href={{channel.url}}
                {{on "click" requireLogin}}
              >
                <img
                  class="deadlock-home__card-image"
                  src="{{@outletArgs.model.imageBase}}{{channel.image}}"
                  alt=""
                />
                <span class="deadlock-home__card-content">
                  <span
                    class="deadlock-home__card-title"
                  >{{channel.title}}</span>
                  <span class="deadlock-home__card-copy">
                    {{channel.description}}
                  </span>
                </span>
              </a>
            {{/each}}
          </div>
        </section>

        <section class="deadlock-home__section" id="deadlock-voice">
          <div class="deadlock-home__section-heading">
            <p class="deadlock-home__eyebrow">
              {{i18n (themePrefix "deadlock_home.voice_eyebrow")}}
            </p>
            <h2>{{i18n (themePrefix "deadlock_home.voice_title")}}</h2>
          </div>

          <div class="deadlock-home__cards --voice">
            <a
              class="deadlock-home__card"
              href={{@outletArgs.model.voiceChannel.url}}
              {{on "click" joinVoiceRoom}}
            >
              <img
                class="deadlock-home__card-image"
                src="{{@outletArgs.model.imageBase}}{{@outletArgs.model.voiceChannel.image}}"
                alt=""
              />
              <span class="deadlock-home__card-content">
                <span class="deadlock-home__card-title">
                  {{@outletArgs.model.voiceChannel.title}}
                </span>
                <span class="deadlock-home__card-copy">
                  {{@outletArgs.model.voiceChannel.description}}
                </span>
              </span>
            </a>
          </div>
        </section>

        <div class="deadlock-home__lists">
          <section class="deadlock-home__panel">
            <div class="deadlock-home__section-heading">
              <p class="deadlock-home__eyebrow">
                {{i18n (themePrefix "deadlock_home.matches_eyebrow")}}
              </p>
              <h2>{{i18n (themePrefix "deadlock_home.matches_title")}}</h2>
            </div>

            <ol class="deadlock-home__list">
              {{#each @outletArgs.model.matches as |match|}}
                <li class="deadlock-home__list-item">
                  <a href={{match.url}}>{{match.title}}</a>
                  <span>{{match.meta}}</span>
                </li>
              {{/each}}
            </ol>
          </section>

          <section class="deadlock-home__panel">
            <div class="deadlock-home__section-heading">
              <p class="deadlock-home__eyebrow">
                {{i18n (themePrefix "deadlock_home.news_eyebrow")}}
              </p>
              <h2>{{i18n (themePrefix "deadlock_home.news_title")}}</h2>
            </div>

            <ol class="deadlock-home__list">
              {{#each @outletArgs.model.news as |item|}}
                <li class="deadlock-home__list-item">
                  <a
                    href={{item.url}}
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    {{item.title}}
                  </a>
                  <span>{{item.meta}}</span>
                </li>
              {{/each}}
            </ol>
          </section>

          <section class="deadlock-home__panel">
            <div class="deadlock-home__section-heading">
              <p class="deadlock-home__eyebrow">
                {{i18n (themePrefix "deadlock_home.ranking_eyebrow")}}
              </p>
              <h2>{{i18n (themePrefix "deadlock_home.ranking_title")}}</h2>
            </div>

            <ol class="deadlock-home__leaderboard">
              {{#each @outletArgs.model.ranking as |player|}}
                <li class="deadlock-home__leaderboard-item">
                  <span class="deadlock-home__rank">#{{player.rank}}</span>
                  <span class="deadlock-home__player">
                    <span class="deadlock-home__flag">{{player.flag}}</span>
                    {{player.player}}
                  </span>
                  <span class="deadlock-home__rating">{{player.mmr}}</span>
                </li>
              {{/each}}
            </ol>
          </section>
        </div>
      </div>
    </template>
  );
});
