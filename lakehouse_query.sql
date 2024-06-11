with s_media_articles as (

    select * from `analytics_warehouse.media_articles_fct`

),

s_social_network_conversations as (

    select * from `analytics_warehouse.social_network_conversations_dim`

),

s_social_network_posts as (

    select * from `analytics_warehouse.social_network_posts_fct`

),

s_social_network_user_profiles as (

    select * from `analytics_warehouse.social_network_user_profiles_dim`

), 

final as (

    select distinct
        s_media_articles.media_article_pk as media_article_fk,
        s_social_network_conversations.social_network_conversation_pk as social_network_conversation_fk,
        s_social_network_posts.social_network_post_pk as social_network_post_fk,
        s_social_network_user_profiles.social_network_user_profile_pk as social_network_user_profile_fk,

        s_media_articles.media_source,
        s_media_articles.article_url,
        s_media_articles.article_title,
        s_media_articles.article_summary,
        s_media_articles.article_description,
        s_media_articles.article_content,
        s_media_articles.article_tags,
        s_media_articles.article_author,
        s_media_articles.article_medias,
        s_media_articles.article_publication_ts,
        s_media_articles.article_modification_ts,

        s_social_network_posts.social_network_source,
        s_social_network_posts.conversation_natural_key,
        count(s_social_network_posts.post_natural_key) over (partition by s_social_network_posts.conversation_natural_key) as conversation_posts_count,

        s_social_network_posts.post_natural_key,
        s_social_network_posts.post_text,
        s_social_network_posts.post_retweet_count,
        s_social_network_posts.post_reply_count,
        s_social_network_posts.post_like_count,
        s_social_network_posts.post_quote_count,
        s_social_network_posts.post_bookmark_count,
        s_social_network_posts.post_impression_count,
        s_social_network_posts.post_creation_ts,

        s_social_network_user_profiles.social_network_profile_natural_key,
        s_social_network_user_profiles.social_network_profile_username,
        s_social_network_user_profiles.social_network_profile_description,
        s_social_network_user_profiles.social_network_profile_location_name,
        s_social_network_user_profiles.social_network_profile_location_country_name,
        s_social_network_user_profiles.social_network_profile_location_country_code,
        s_social_network_user_profiles.social_network_profile_location_admin1_name,
        s_social_network_user_profiles.social_network_profile_location_admin1_code,
        s_social_network_user_profiles.social_network_profile_location_latitude,
        s_social_network_user_profiles.social_network_profile_location_longitude,
        s_social_network_user_profiles.social_network_profile_creation_ts

    from s_media_articles
    left join s_social_network_conversations on s_media_articles.media_article_pk = s_social_network_conversations.media_article_fk
    left join s_social_network_posts on s_social_network_conversations.social_network_conversation_pk = s_social_network_posts.social_network_conversation_fk
    left join s_social_network_user_profiles on s_social_network_posts.social_network_user_profile_fk = s_social_network_user_profiles.social_network_user_profile_pk

)

select * from final
where date(article_publication_ts) = '2024-05-28'
order by article_publication_ts desc, social_network_conversation_fk, post_creation_ts
