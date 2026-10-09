import type { APIRoute } from 'astro';
import { getPosts, formatDate } from '../utils/posts';

export const GET: APIRoute = async () => {
	const posts = await getPosts();
	const index = posts.map((post) => ({
		slug: post.id,
		title: post.data.title,
		description: post.data.description,
		tags: post.data.tags,
		date: formatDate(post.data.pubDate),
	}));
	return new Response(JSON.stringify(index), {
		headers: { 'content-type': 'application/json' },
	});
};
