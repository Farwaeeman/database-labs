-- Lab 1: Analytical Queries
-- Author: Farwa Eeman
-- Date: February 6, 2026

-- Query 1: Books by rating
SELECT title, author, rating
FROM books_read
ORDER BY rating DESC;

-- Query 2: Average pages by category
SELECT category, AVG(pages) as avg_pages
FROM books_read
GROUP BY category;
-- Query 3: Total pages read
SELECT SUM(pages) as total_pages_read
FROM books_read;

-- Query 5: Monthly reading progress
SELECT
    TO_CHAR(date_finished, 'YYYY-MM') as month,
    COUNT(*) as books_finished,
    SUM(pages) as pages_read
FROM books_read
GROUP BY TO_CHAR(date_finished, 'YYYY-MM')
ORDER BY month;
