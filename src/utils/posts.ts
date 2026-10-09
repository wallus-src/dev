import { getCollection, type CollectionEntry } from 'astro:content';

export type Post = CollectionEntry<'blog'>;

export async function getPosts(): Promise<Post[]> {
	const posts = await getCollection('blog', ({ data }) => !data.draft);
	return posts.sort((a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf());
}

export function readingTime(body: string | undefined): number {
	if (!body) return 1;
	const words = body.replace(/```[\s\S]*?```/g, ' ').split(/\s+/).filter(Boolean).length;
	return Math.max(1, Math.round(words / 220));
}

export function formatDate(date: Date): string {
	return date.toLocaleDateString('en-us', {
		year: 'numeric',
		month: 'short',
		day: 'numeric',
		timeZone: 'UTC',
	});
}

export function getAllTags(posts: Post[]): [string, number][] {
	const counts = new Map<string, number>();
	for (const post of posts) {
		for (const tag of post.data.tags) {
			counts.set(tag, (counts.get(tag) ?? 0) + 1);
		}
	}
	return [...counts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]));
}

const base = import.meta.env.BASE_URL.replace(/\/$/, '');

/** Prefix an internal path with the configured base (e.g. '/dev' on GitHub Pages). */
export function link(path: string): string {
	return `${base}${path}`;
}

export function nextPrev(posts: Post[], current: Post): { prev?: Post; next?: Post } {
	const idx = posts.findIndex((p) => p.id === current.id);
	return {
		next: idx > 0 ? posts[idx - 1] : undefined,
		prev: idx < posts.length - 1 ? posts[idx + 1] : undefined,
	};
}
