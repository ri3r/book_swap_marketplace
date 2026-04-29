import { initializeApp } from 'firebase/app';
import { getFirestore, collection, doc, setDoc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: 'AIzaSyBSSyv7SAJ7klf0XCf2FW_g1Ru47y1xAAM',
  authDomain: 'marketplace-12ea3.firebaseapp.com',
  projectId: 'marketplace-12ea3',
  storageBucket: 'marketplace-12ea3.firebasestorage.app',
  messagingSenderId: '481739383143',
  appId: '1:481739383143:web:cf3b85ce828a239bdf8fc2',
};

const books = [
  {
    id: 'book_001',
    title: 'Der Herr der Ringe',
    author: 'J.R.R. Tolkien',
    isbn: '978-3-608-93006-4',
    price: 8.50,
    condition: 'good',
    type: 'sale',
    category: 'fiction',
    description: 'Klassiker der Fantasy-Literatur, leichte Gebrauchsspuren am Rücken.',
    sellerName: 'Anna M.',
    sellerContact: 'anna@example.com',
    location: 'München',
    datePosted: '2026-04-20T10:00:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_002',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    isbn: '978-0-13-235088-4',
    price: 0,
    condition: 'likeNew',
    type: 'swap',
    category: 'technology',
    description: 'Suche im Tausch ein anderes Software-Buch. Sehr guter Zustand.',
    sellerName: 'Lukas B.',
    sellerContact: '+49 151 12345678',
    location: 'Berlin',
    datePosted: '2026-04-22T14:30:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_003',
    title: 'Harry Potter und der Stein der Weisen',
    author: 'J.K. Rowling',
    isbn: '978-3-551-35401-5',
    price: 0,
    condition: 'fair',
    type: 'free',
    category: 'fiction',
    description: 'Kindergerecht gelesen, etwas verblasst. Gerne weitergeben!',
    sellerName: 'Marie K.',
    sellerContact: 'marie.k@example.com',
    location: 'Hamburg',
    datePosted: '2026-04-23T09:15:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_004',
    title: 'Sapiens: Eine kurze Geschichte der Menschheit',
    author: 'Yuval Noah Harari',
    price: 12.00,
    condition: 'likeNew',
    type: 'sale',
    category: 'history',
    description: 'Kaum gelesen, wie neu. Absolut empfehlenswert.',
    sellerName: 'Tom S.',
    sellerContact: 'tom.s@example.com',
    location: 'Frankfurt',
    datePosted: '2026-04-24T11:00:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_005',
    title: 'Grundlagen der Betriebswirtschaftslehre',
    author: 'Erich Gutenberg',
    isbn: '978-3-540-85077-0',
    price: 15.00,
    condition: 'good',
    type: 'sale',
    category: 'textbook',
    description: 'Uni-Lehrbuch, mit Markierungen. Ideal für BWL-Studenten.',
    sellerName: 'Nina P.',
    sellerContact: 'nina.p@example.com',
    location: 'Köln',
    datePosted: '2026-04-25T08:00:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_006',
    title: 'Die Physiker',
    author: 'Friedrich Dürrenmatt',
    price: 4.00,
    condition: 'good',
    type: 'sale',
    category: 'fiction',
    description: 'Schulausgabe, wenige Anmerkungen mit Bleistift.',
    sellerName: 'Felix R.',
    sellerContact: '+49 160 98765432',
    location: 'Stuttgart',
    datePosted: '2026-04-26T16:45:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_007',
    title: 'Eine kurze Geschichte der Zeit',
    author: 'Stephen Hawking',
    price: 6.00,
    condition: 'fair',
    type: 'swap',
    category: 'science',
    description: 'Tausche gegen Biologie- oder Physikbuch. Einband leicht beschädigt.',
    sellerName: 'Sara L.',
    sellerContact: 'sara.l@example.com',
    location: 'München',
    datePosted: '2026-04-27T13:20:00.000Z',
    isAvailable: true,
  },
  {
    id: 'book_008',
    title: 'Pippi Langstrumpf',
    author: 'Astrid Lindgren',
    price: 0,
    condition: 'good',
    type: 'free',
    category: 'childrens',
    description: 'Meine Kinder haben es geliebt. Weitergeben an die nächste Generation!',
    sellerName: 'Claudia W.',
    sellerContact: 'claudia.w@example.com',
    location: 'Düsseldorf',
    datePosted: '2026-04-28T10:00:00.000Z',
    isAvailable: true,
  },
];

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

console.log(`Seeding ${books.length} Bücher in Firestore...\n`);

for (const book of books) {
  const ref = doc(collection(db, 'books'), book.id);
  await setDoc(ref, book);
  console.log(`✓ ${book.title}`);
}

console.log('\nFertig! Alle Testdaten wurden eingefügt.');
process.exit(0);
