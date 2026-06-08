import { themePrefix } from "virtual:theme";
import { ajax } from "discourse/lib/ajax";
import { apiInitializer } from "discourse/lib/api";
import { i18n } from "discourse-i18n";

const HOME = {
  playersOnline: "53,802",
  patchNotes: {
    title: "Balance update 06-06-2026",
    excerpt:
      "Weapon falloff tuning, Mirage lane fixes, and another pass on experimental item timings.",
    url: "/c/changelog",
  },
  categories: [
    {
      title: "Hero builds",
      description: "Discuss lane plans, item paths, and matchup notes.",
      url: "/c/hero-builds",
    },
    {
      title: "Strategy lab",
      description: "Share macro calls, timing windows, and team compositions.",
      url: "/c/strategy",
    },
  ],
  chatChannels: [
    {
      title: "Looking for group",
      description: "Find teammates for ranked and casual stacks.",
      url: "/chat/channel/lfg",
    },
    {
      title: "Scrim finder",
      description: "Coordinate practice blocks and lobby rules.",
      url: "/chat/channel/scrims",
    },
    {
      title: "Live match chat",
      description: "Follow tournaments and community showmatches.",
      url: "/chat/channel/live-matches",
    },
  ],
  matches: [
    {
      title: "Amber Hand vs. Midboss Union",
      meta: "June 8, 2026, 19:00 UTC",
      url: "/t/amber-hand-vs-midboss-union",
    },
    {
      title: "Canal Saints vs. Pocket Aces",
      meta: "June 9, 2026, 21:30 UTC",
      url: "/t/canal-saints-vs-pocket-aces",
    },
    {
      title: "Oracle Cup qualifiers",
      meta: "June 14, 2026",
      url: "/t/oracle-cup-qualifiers",
    },
  ],
  news: [
    {
      title: "New hero labs are open for weekend testing",
      meta: "Steam news",
      url: "https://store.steampowered.com/news/app/1422450",
    },
    {
      title: "Matchmaking update focuses on duo queue spread",
      meta: "Steam news",
      url: "https://store.steampowered.com/news/app/1422450",
    },
    {
      title: "Community tournament tools enter preview",
      meta: "Steam news",
      url: "https://store.steampowered.com/news/app/1422450",
    },
  ],
  ranking: [
    { rank: 1, player: "Pale Lantern", mmr: "12,840" },
    { rank: 2, player: "Canal King", mmr: "12,695" },
    { rank: 3, player: "Seven Bells", mmr: "12,604" },
    { rank: 4, player: "Ivy Circuit", mmr: "12,511" },
    { rank: 5, player: "Wraithline", mmr: "12,448" },
    { rank: 6, player: "Mercury Vow", mmr: "12,380" },
    { rank: 7, player: "Haze Limit", mmr: "12,322" },
    { rank: 8, player: "Kelvin Draft", mmr: "12,210" },
    { rank: 9, player: "Bebop Prime", mmr: "12,168" },
    { rank: 10, player: "Infernal Lane", mmr: "12,101" },
  ],
};

async function latestPatchNotes() {
  try {
    const response = await ajax("/c/changelog/l/latest.json");
    const topic = response.topic_list?.topics?.[0];

    if (topic) {
      return {
        title: topic.title,
        excerpt: topic.excerpt || HOME.patchNotes.excerpt,
        url: `/t/${topic.slug}/${topic.id}`,
      };
    }
  } catch {
    // Demo sites may not have a changelog category yet.
  }

  return HOME.patchNotes;
}

export default apiInitializer((api) => {
  api.registerBehaviorTransformer("custom-homepage-model", async () => ({
    ...HOME,
    patchNotes: await latestPatchNotes(),
  }));

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
            <span class="deadlock-home__feature-title">
              {{@outletArgs.model.patchNotes.title}}
            </span>
            <span class="deadlock-home__feature-copy">
              {{@outletArgs.model.patchNotes.excerpt}}
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
                <span
                  class="deadlock-home__card-title"
                >{{category.title}}</span>
                <span class="deadlock-home__card-copy">
                  {{category.description}}
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
              <a class="deadlock-home__card" href={{channel.url}}>
                <span class="deadlock-home__card-title">{{channel.title}}</span>
                <span class="deadlock-home__card-copy">
                  {{channel.description}}
                </span>
              </a>
            {{/each}}
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
                  <span class="deadlock-home__player">{{player.player}}</span>
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
