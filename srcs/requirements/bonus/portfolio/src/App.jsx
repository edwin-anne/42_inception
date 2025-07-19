import React, { useState } from "react";
import { motion } from "framer-motion";
import { Linkedin, Github, Mail, Phone } from "lucide-react";

/*************************
 * Composants Tailwind   *
 *************************/
const Button = ({ children, variant = "primary", size = "md", className = "", asChild, ...props }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-lg font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2";
  const variants = {
    primary: "bg-indigo-600 text-white hover:bg-indigo-700 focus:ring-indigo-500",
    secondary: "bg-slate-200 text-slate-900 hover:bg-slate-300 focus:ring-slate-500",
    outline: "border border-slate-300 bg-white text-slate-700 hover:bg-slate-50 focus:ring-slate-500"
  };
  const sizes = {
    sm: "px-3 py-2 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base"
  };
  
  const classes = `${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`;
  
  if (asChild && React.isValidElement(children)) {
    return React.cloneElement(children, {
      className: `${children.props.className || ''} ${classes}`,
      ...props
    });
  }
  
  return (
    <button className={classes} {...props}>
      {children}
    </button>
  );
};

const Card = ({ children, className = "", ...props }) => (
  <div className={`bg-white border border-slate-200 rounded-lg shadow-sm ${className}`} {...props}>
    {children}
  </div>
);

const CardContent = ({ children, className = "", ...props }) => (
  <div className={`p-6 ${className}`} {...props}>
    {children}
  </div>
);

const Modal = ({ isOpen, onClose, title, children }) => {
  if (!isOpen) return null;
  
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div className="fixed inset-0 bg-black bg-opacity-50" onClick={onClose} />
      <div className="relative bg-white rounded-lg shadow-lg max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold">{title}</h3>
            <button 
              onClick={onClose}
              className="text-slate-400 hover:text-slate-600 text-2xl"
            >
              ×
            </button>
          </div>
          {children}
        </div>
      </div>
    </div>
  );
};

/*************************
 * Reusable Section bloc *
 *************************/
const Section = ({ id, title, children }) => (
  <section id={id} className="py-16 px-4 md:px-8 scroll-mt-20">
    <motion.h2
      className="text-3xl md:text-4xl font-bold mb-8 text-center"
      initial={{ opacity: 0, y: 30 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.6 }}
    >
      {title}
    </motion.h2>
    {children}
  </section>
);

/******************
 * Static content *
 ******************/
const experiences = [
  {
    title: "Stage – Orange LABS (Cesson‑Sévigné)",
    date: "Avril – Mai 2022 (3 sem.) / Mai – Juin 2023 (5 sem.)",
    description:
      "Mise en place de réseau FTTH · Découverte du développement informatique",
  },
  {
    title: "Job d’été – Sofrilog",
    date: "Été 2023 & Été 2024 (2 mois)",
    description: "Ouvrier Polyvalent",
  },
  {
    title: "Stage – Kéolis Rennes",
    date: "Janvier 2024 (4 sem.)",
    description: "Installation et paramétrage de clients légers",
  },
  {
    title: "Stage 3ᵉ – 6TM",
    date: "Janvier 2020 (1 sem.)",
    description: "Découverte de l’entreprise",
  },
];

const projects = [
  {
    name: "Sacré TV",
    tagline: "Affichage dynamique au lycée Sacré‑Cœur",
    image: "/images/sacre-tv.webp",
    description:
      "Solution d'affichage dynamique temps réel pour le lycée Sacré‑Cœur avec tableau d'administration, déploiement Raspberry Pi et monitoring Prometheus.",
  },
  {
    name: "Pêch’App",
    tagline: "Reconnaissance de poissons & législation",
    image: "/images/pechapp.webp",
    description:
      "Application mobile Flutter réalisée en partenariat avec l’École du service public de la mer : IA TensorFlow Lite pour l’identification des poissons, base embarquée des tailles minimales légales, mode hors‑ligne.",
  },
  {
    name: "UNTEC Hackathon",
    tagline:
      "Gagnant — Calcul de coût global partagé valorisant les bénéfices sociaux d’un bâtiment",
    image: "/images/untec.webp",
    description:
      "Prototype web React + Django. Algorithme de prise de décision multi‑critères, visualisations Recharts, export XLSX automatisé. Prix « Innovation sociale ».",
  },
];

const educations = [
  {
    school: "École 42 Le Havre",
    period: "2024 – 2027",
    diploma:
      "RNCP 7 Expert en architecture informatique – Option Systèmes d’information & réseaux",
  },
  {
    school: "Lycée Sacré‑Cœur, Saint‑Brieuc",
    period: "2021 – 2024",
    diploma: "Bac Pro Systèmes Numériques",
  },
];

const skills = [
  "Développement Web & Logiciel",
  "Gestion de réseau FTTH",
  "Linux / Bash",
  "Git & GitHub",
  "Anglais professionnel",
  "Diplôme SST (Sauveteur Secouriste au Travail)",
];

const hobbies = ["VTT", "Badminton"];

/*******************
 * Main component  *
 *******************/
export default function PortfolioSite() {
  const [selectedProject, setSelectedProject] = useState(null);

  return (
    <main className="font-sans antialiased scroll-smooth bg-gradient-to-br from-white to-slate-100 text-slate-800">
      {/* Hero */}
      <section className="min-h-screen flex flex-col justify-center items-center text-center px-4">
        <motion.h1
          className="text-4xl md:text-6xl font-extrabold leading-tight mb-4"
          initial={{ opacity: 0, y: -40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
        >
          Edwin <span className="text-indigo-600">Anne</span>
        </motion.h1>
        <motion.p
          className="text-lg md:text-2xl max-w-xl mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1 }}
        >
          Étudiant à l’École 42 • Passionné par le développement informatique &amp; les systèmes réseaux • À la recherche d’une alternance dès septembre 2025
        </motion.p>
        <div className="flex gap-4">
          <Button asChild size="lg" className="rounded-2xl shadow-xl">
            <a href="#contact">Me contacter</a>
          </Button>
          <Button asChild variant="outline" size="lg" className="rounded-2xl">
            <a href="https://github.com/edwin-anne" target="_blank" rel="noreferrer">
              <Github className="mr-2 h-5 w-5" /> GitHub
            </a>
          </Button>
        </div>
      </section>

      {/* About */}
      <Section id="about" title="À propos">
        <motion.div
          className="max-w-3xl mx-auto text-lg leading-relaxed"
          initial={{ opacity: 0, y: 30 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
        >
          <p>
            Bonjour ! Je m’appelle Edwin, j’ai 19 ans et je me passionne pour la création de solutions numériques qui allient performance technique et impact utilisateur. Fort de plusieurs expériences professionnelles variées et de projets personnels ambitieux, je cultive un goût prononcé pour l’innovation, le travail en équipe et l’apprentissage continu.
          </p>
        </motion.div>
      </Section>

      {/* Projects (avant Expériences) */}
      <Section id="projects" title="Projets">
        <div className="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
          {projects.map((proj) => (
            <Card key={proj.name} className="shadow-lg rounded-2xl h-full">
              <CardContent className="p-6 flex flex-col justify-between h-full">
                <div>
                  <h3 className="text-xl font-semibold mb-2">{proj.name}</h3>
                  <p className="text-sm text-slate-600">{proj.tagline}</p>
                </div>
                <Button 
                  className="mt-4" 
                  variant="secondary"
                  onClick={() => setSelectedProject(proj)}
                >
                  Voir plus
                </Button>
              </CardContent>
            </Card>
          ))}
        </div>
        
        <Modal 
          isOpen={!!selectedProject} 
          onClose={() => setSelectedProject(null)}
          title={selectedProject?.name}
        >
          {selectedProject && (
            <>
              <img
                src={selectedProject.image}
                alt={selectedProject.name}
                className="rounded-xl mb-4 object-cover w-full h-64"
              />
              <p className="leading-relaxed">{selectedProject.description}</p>
              <div className="text-right mt-4">
                <Button variant="outline" onClick={() => setSelectedProject(null)}>
                  Fermer
                </Button>
              </div>
            </>
          )}
        </Modal>
      </Section>

      {/* Experience */}
      <Section id="experience" title="Expériences">
        <div className="grid md:grid-cols-2 gap-6 max-w-5xl mx-auto">
          {experiences.map((exp) => (
            <motion.div
              key={exp.title}
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5 }}
            >
              <Card className="h-full shadow-md rounded-2xl">
                <CardContent className="p-6 space-y-2">
                  <h3 className="text-xl font-semibold">{exp.title}</h3>
                  <p className="text-sm italic text-indigo-600">{exp.date}</p>
                  <p>{exp.description}</p>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      </Section>

      {/* Education */}
      <Section id="education" title="Formation">
        <div className="flex flex-col gap-6 max-w-3xl mx-auto">
          {educations.map((edu) => (
            <motion.div
              key={edu.school}
              initial={{ opacity: 0, x: -40 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5 }}
            >
              <Card className="shadow-md rounded-2xl">
                <CardContent className="p-6 space-y-1">
                  <h3 className="text-lg font-semibold">{edu.school}</h3>
                  <p className="text-sm italic text-indigo-600">{edu.period}</p>
                  <p>{edu.diploma}</p>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      </Section>

      {/* Skills */}
      <Section id="skills" title="Compétences & Certifications">
        <motion.ul
          className="grid sm:grid-cols-2 md:grid-cols-3 gap-4 max-w-4xl mx-auto"
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true }}
          variants={{
            hidden: {},
            visible: { transition: { staggerChildren: 0.1 } },
          }}
        >
          {skills.map((skill) => (
            <motion.li
              key={skill}
              className="bg-indigo-50 shadow rounded-xl p-3 text-center"
              variants={{ hidden: { opacity: 0, y: 20 }, visible: { opacity: 1, y: 0 } }}
            >
              {skill}
            </motion.li>
          ))}
        </motion.ul>
      </Section>

      {/* Hobbies */}
      <Section id="hobbies" title="Loisirs">
        <div className="flex justify-center gap-4">
          {hobbies.map((hobby) => (
            <span key={hobby} className="px-4 py-2 bg-slate-200 rounded-full shadow-md">
              {hobby}
            </span>
          ))}
        </div>
      </Section>

      {/* Contact */}
      <Section id="contact" title="Contact">
        <div className="flex flex-col items-center gap-4 text-lg">
          <a href="mailto:edwin_anne@outlook.fr" className="flex items-center gap-2 hover:text-indigo-600">
            <Mail className="h-5 w-5" /> edwin_anne@outlook.fr
          </a>
          <a href="tel:+33784501744" className="flex items-center gap-2 hover:text-indigo-600">
            <Phone className="h-5 w-5" /> 07 84 50 17 44
          </a>
          <a
            href="https://www.linkedin.com/in/edwin-anne"
            target="_blank"
            rel="noreferrer"
            className="flex items-center gap-2 hover:text-indigo-600"
          >
            <Linkedin className="h-5 w-5" /> Linkedin
          </a>
        </div>
        <p className="text-center mt-8 text-sm text-slate-500">Rennes (35000) • Le Havre (76600)</p>
      </Section>

      <footer className="py-6 text-center text-sm text-slate-500">
        © {new Date().getFullYear()} Edwin Anne. Tous droits réservés.
      </footer>
    </main>
  );
}
