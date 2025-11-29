
-- BlogSystem SQL Schema
CREATE DATABASE BlogSystem;
GO
USE BlogSystem;
GO

CREATE TABLE Users (
    UserId INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(150) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    AvatarUrl NVARCHAR(255),
    Bio NVARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

CREATE TABLE Roles (
    RoleId INT IDENTITY PRIMARY KEY,
    RoleName NVARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE UserRoles (
    UserId INT,
    RoleId INT,
    PRIMARY KEY(UserId, RoleId),
    FOREIGN KEY(UserId) REFERENCES Users(UserId),
    FOREIGN KEY(RoleId) REFERENCES Roles(RoleId)
);

CREATE TABLE Categories (
    CategoryId INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    Slug NVARCHAR(150) UNIQUE
);

CREATE TABLE Posts (
    PostId INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Slug NVARCHAR(255) UNIQUE NOT NULL,
    ThumbnailUrl NVARCHAR(255),
    Content NVARCHAR(MAX) NOT NULL,
    Summary NVARCHAR(500),
    CategoryId INT,
    AuthorId INT,
    ViewCount INT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Draft',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    FOREIGN KEY(CategoryId) REFERENCES Categories(CategoryId),
    FOREIGN KEY(AuthorId) REFERENCES Users(UserId)
);

CREATE TABLE Tags (
    TagId INT IDENTITY PRIMARY KEY,
    TagName NVARCHAR(50) UNIQUE NOT NULL,
    Slug NVARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE PostTags (
    PostId INT,
    TagId INT,
    PRIMARY KEY(PostId, TagId),
    FOREIGN KEY(PostId) REFERENCES Posts(PostId),
    FOREIGN KEY(TagId) REFERENCES Tags(TagId)
);

CREATE TABLE Comments (
    CommentId INT IDENTITY PRIMARY KEY,
    PostId INT,
    UserId INT,
    Content NVARCHAR(1000) NOT NULL,
    ParentId INT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 1,
    FOREIGN KEY(PostId) REFERENCES Posts(PostId),
    FOREIGN KEY(UserId) REFERENCES Users(UserId),
    FOREIGN KEY(ParentId) REFERENCES Comments(CommentId)
);

CREATE TABLE Likes (
    UserId INT,
    PostId INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    PRIMARY KEY(UserId, PostId),
    FOREIGN KEY(UserId) REFERENCES Users(UserId),
    FOREIGN KEY(PostId) REFERENCES Posts(PostId)
);

CREATE TABLE Bookmarks (
    UserId INT,
    PostId INT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    PRIMARY KEY(UserId, PostId),
    FOREIGN KEY(UserId) REFERENCES Users(UserId),
    FOREIGN KEY(PostId) REFERENCES Posts(PostId)
);

CREATE TABLE AuditLogs (
    LogId INT IDENTITY PRIMARY KEY,
    UserId INT,
    Action NVARCHAR(255),
    Target NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY(UserId) REFERENCES Users(UserId)
);

INSERT INTO Roles(RoleName)
VALUES ('Admin'), ('User');
