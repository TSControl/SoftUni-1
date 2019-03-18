using Book_Library.Models;
using Microsoft.AspNet.Identity;
using System.Linq;
using System.Net;
using System.Web.Mvc;

namespace Book_Library.Controllers
{
    public class BookController : Controller
    {
        // GET: Book
        public ActionResult Index()
        {
            using (var db = new ApplicationDbContext())
            {
                var books = db.Books.ToList();
                return View(books);
            }
        }

        // GET: Book/Details/5
        public ActionResult Details(int id)
        {
            
            using (var db = new ApplicationDbContext())
            {
                var book = db.Books.Include(b => b.Author).SingleOrDefault(b => b.Id == id);
                if (book == null)
                {
                    return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                }
                return View(book);
            }
        }

        // GET: Book/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Book/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,Title,Description")] Book book)
        {
            using (var db = new ApplicationDbContext())
            {
                var books = db.Books.ToList();
                if (ModelState.IsValid)
                {
                    book.AuthorId = User.Identity.GetUserId();
                    db.Books.Add(book);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View(books);
            }
        }

        // GET: Book/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Book/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Book/Delete/5
        [Authorize]
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Book/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
