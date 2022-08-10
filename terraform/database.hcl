schema "fresh_video" {
  comment = "Production Database."
  charset = "utf8mb4"
  collate = "utf8mb4_0900_ai_ci"
}

table "Actor" {
  comment = "Actors"
  schema = schema.fresh_video
  column "Id" {
    type           = int
    null           = false
    auto_increment = true
    unsigned       = true    
  }
  column "Name" {
    type    = varchar(255)
    null    = false
    comment = "Provider Name"
  }
  column "Slug" {
    type    = varchar(255)
    null    = false
    comment = "Provider Slug"
  }
  column "IMDB" {
    type    = varchar(255)
    null    = false
    comment = "IMDB URL"
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
  index "idx_unq_actor_slug" {
    columns = [
      column.Slug
    ]
    unique = true
  }
}

table "ActorRelationship" {
  comment = "Media to Actor relationship"
  schema = schema.fresh_video
  column "Actor" {
    type           = int
    null           = false
    unsigned       = true    
  }
  column "Media" {
    type           = int
    null           = false
    unsigned       = true    
  }
  column "Created" {
    type    = datetime(0)
    null    = false
    default = sql("CURRENT_TIMESTAMP(0)")
    comment = "Content first seen."
  }
  index "idx_unq_provider_relationship" {
    columns = [
      column.Actor,
      column.Media
    ]
    unique = true
  }
}

table "Provider" {
  comment = "Media Providers"
  schema = schema.fresh_video
  column "Id" {
    type           = int
    null           = false
    auto_increment = true
    unsigned       = true    
  }
  column "Name" {
    type    = varchar(255)
    null    = false
    comment = "Provider Name"
  }
  column "Link" {
    type    = varchar(255)
    null    = false
    comment = "Provider URL"
  }
  column "Slug" {
    type    = varchar(255)
    null    = false
    comment = "Provider Slug"
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
  index "idx_unq_provider_slug" {
    columns = [
      column.Slug
    ]
    unique = true
  }
}

table "ProviderRelationship" {
  comment = "Media to Provider relationship"
  schema = schema.fresh_video
  column "Provider" {
    type           = int
    null           = false
    unsigned       = true    
  }
  column "Media" {
    type           = int
    null           = false
    unsigned       = true    
  }
  column "Country" {
    type    = varchar(2)
    null    = false
    comment = "Country ISO code that media was scraped from."
  }
  column "Link" {
    type    = varchar(512)
    null    = false
    comment = "Media link."
  }
  column "Created" {
    type    = datetime(0)
    null    = false
    default = sql("CURRENT_TIMESTAMP(0)")
    comment = "Content first seen."
  }
  column "Removed" {
    type    = datetime(0)
    null    = true
    comment = "Content removed."
  }
  column "Seen" {
    type    = datetime(0)
    null    = false
    default = sql("CURRENT_TIMESTAMP(0)")
    comment = "Content last seen."
  }
  column "Rating" {
    type    = varchar(16)
    null    = true
    comment = "Content Rating."
  }
  index "idx_unq_provider_relationship" {
    columns = [
      column.Provider,
      column.Media,
      column.Country,
      column.Link
    ]
    unique = true
  }
}

table "Media" {
  comment = "Sourced Media"
  schema  = schema.fresh_video
  column "Id" {
    type           = int
    null           = false
    auto_increment = true
    unsigned       = true
    comment        = "ID."
  }
  column "Created" {
    type    = datetime(0)
    null    = false
    default = sql("CURRENT_TIMESTAMP(0)")
    comment = "Content first seen."
  }
  column "Seen" {
    type      = datetime(0)
    null      = true
    on_update = sql("CURRENT_TIMESTAMP(0)")
    comment   = "Last seen time."
  }
  column "Active" {
    type     = tinyint(1)
    null     = false
    unsigned = true
    default  = true
    comment  = "Content Available."
  }
  column "Slug" {
    type    = varchar(255)
    null    = false
    comment = "Title of Media."
  }
  column "Title" {
    type    = varchar(255)
    null    = false
    comment = "Title of Media."
  }
  column "Year" {
    type    = varchar(255)
    null    = false
    comment = "Title of Media."
  }
  column "ReleaseDate" {
    type    = varchar(255)
    null    = false
    comment = "Title of Media."
  }
  column "Description" {
    type    = text
    null    = true
    comment = "Title of Media."
  }
  column "Image" {
    type    = varchar(255)
    null    = true
    comment = "Title of Media."
  }
  column "Imdb" {
    type    = varchar(1024)
    null    = true
    comment = "Title of Media."
  }
  column "Wikipedia" {
    type    = varchar(1024)
    null    = true
    comment = "Title of Media."
  }
  column "Medium" {
    type     = enum("movie","tvShow","tvEpisode")
    null     = false
    unsigned = true
    comment  = "Content Medium."
  }
  column "Season" {
    type     = smallint(3)
    null     = true
    unsigned = true
    comment  = "TV Season"
  }
  column "Episode" {
    type     = smallint(3)
    null     = true
    unsigned = true
    comment  = "TV Episode"
  }
  column "Parent" {
    type      = int
    unsigned  = true
    null      = true
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
  index "idx_unq_slug" {
    columns = [
      column.Slug,
      column.Medium,
      column.Parent,
      column.Season,
      column.Episode
    ]
    unique = true
  }
}

table "ImdbTitleBasics" {
  comment = "Imdb Database"
  schema = schema.fresh_video
  column "Id" {
    type           = varchar(10)
    null           = false
  }
  column "Type" {
    type     = enum("short","movie","tvEpisode","tvSeries","tvMiniSeries","tvMovie","video","tvShort","videoGame","tvSpecial")
    null     = false
    unsigned = true
    comment  = "Content Medium."
  }
  column "PrimaryTitle" {
    type    = varchar(255)
    null    = false
    comment = "Primary Title"
  }
  column "OriginalTitle" {
    type    = varchar(255)
    null    = false
    comment = "Original Title"
  }
  column "IsAdult" {
    type     = tinyint(1)
    null     = false
    unsigned = true
    default  = true
    comment  = "Content Available."
  }
  column "StartYear" {
    type     = year
    null     = true
    unsigned = true
    comment  = "Start Year"
  }
  column "EndYear" {
    type     = year
    null     = true
    comment  = "End Year"
  }
  column "RuntimeMinutes" {
    type     = smallint(4)
    null     = true
    unsigned = true
    comment  = "Runtime Minutes"
  }
  column "Genres" {
    type    = varchar(255)
    null    = false
    comment = "Genres, CSV"
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
  index "idx_ft_title" {
    columns = [
      column.PrimaryTitle,
      column.OriginalTitle
    ]
    unique = false
    type   = "FULLTEXT"
  }
  index "idx_hash_imdb_title_basics" {
    columns = [
      column.Type,
      column.StartYear,
      column.EndYear
    ]
    unique = false
    type   = "HASH"
  }
}

table "ImdbNameBasics" {
  comment = "Imdb Name Basics"
  schema = schema.fresh_video
  column "Id" {
    type           = varchar(10)
    null           = false
  }
  column "Name" {
    type    = varchar(255)
    null    = false
    comment = "Primary Title"
  }
  column "BirthYear" {
    type     = year
    null     = true
    unsigned = true
    comment  = "Birth Year"
  }
  column "DeathYear" {
    type     = year
    null     = true
    comment  = "Death Year"
  }
  column "PrimaryProfession" {
    type    = varchar(255)
    null    = false
    comment = "Primary Profession"
  }
  column "KnownForTitles" {
    type    = text
    null    = false
    comment = "Known for titles"
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
  index "idx_ft_imdb_title_name" {
    columns = [
      column.Name
    ]
    unique = false
    type   = "FULLTEXT"
  }
}

table "ImdbRatings" {
  comment = "Imdb Ratings"
  schema = schema.fresh_video
  column "Id" {
    type    = varchar(10)
    null    = false
    comment = "Title ID"
  }
  column "AverageRating" {
    type    = decimal(1)
    null    = false
    comment = "Average Rating"
  }
  column "NumVotes" {
    type     = int
    unsigned = true
    comment  = "Number of Votes"
  }
  primary_key {
    columns = [
      column.Id
    ]
  }
}

table "ImdbTitleCrew" {
  comment = "Imdb Crew Association"
  schema = schema.fresh_video
  column "Title" {
    type    = varchar(10)
    null    = false
    comment = "Title ID"
  }
  column "Director" {
    type    = varchar(10)
    null    = true
    comment = "Director"
  }
  column "Writer" {
    type     = varchar(10)
    null     = true
    comment  = "Writer"
  }
  primary_key {
    columns = [
      column.Title
    ]
  }
}

table "ImdbTitleEpisode" {
  comment = "Imdb Episodes"
  schema = schema.fresh_video
  column "Child" {
    type    = varchar(10)
    null    = false
    comment = "Episode ID"
  }
  column "Parent" {
    type    = varchar(10)
    null    = false
    comment = "Series ID"
  }
  column "Season" {
    type     = smallint(4)
    null    = false
    unsigned = true
    comment  = "Season"
  }
  column "Episode" {
    type     = smallint(4)
    null    = false
    unsigned = true
    comment  = "Episode"
  }
  primary_key {
    columns = [
      column.Child,
      column.Parent,
      column.Season,
      column.Episode
    ]
  }
}

table "ImdbPrincipals" {
  comment = "Imdb Episodes"
  schema = schema.fresh_video
  column "Id" {
    type    = varchar(10)
    null    = false
    comment = "Movie ID"
  }
  column "Order" {
    type     = smallint(4)
    unsigned = true
    null     = true
    comment  = "Order"
  }
  column "Actor" {
    type    = varchar(10)
    null    = false
    comment = "Actor ID"
  }
  column "Category" {
    type    = varchar(255)
    null    = true
    comment = "Category"
  }
  column "Job" {
    type    = varchar(255)
    null    = true
    comment = "Job"
  }
  column "Characeters" {
    type    = varchar(255)
    null    = true
    comment = "Charecters"
  }
  primary_key {
    columns = [
      column.Id,
      column.Actor
    ]
  }
}

table "ImdbAkas" {
  comment = "Imdb Akas"
  schema = schema.fresh_video
  column "Id" {
    type    = varchar(10)
    null    = false
    comment = "Movie ID"
  }
  column "Order" {
    type     = smallint(4)
    unsigned = true
    null     = false
    comment  = "Order"
  }
  column "Title" {
    type    = varchar(255)
    null    = true
    comment = "Title"
  }
  column "Region" {
    type    = varchar(2)
    null    = true
    comment = "Region"
  }
  column "Language" {
    type    = varchar(255)
    null    = true
    comment = "Language"
  }
  column "Type" {
    type     = enum("alternative","dvd","festival","tv","video","working","original","imdbDisplay")
    null     = true
    comment  = "Content Medium."
  }
  column "Attributes" {
    type    = varchar(255)
    null    = true
    comment = "Attributes"
  }
  column "isOriginalTitle" {
    type     = tinyint(1)
    null     = false
    unsigned = true
    default  = true
    comment  = "Original Title"
  }
  primary_key {
    columns = [
      column.Id,
      column.Order
    ]
  }
  
}