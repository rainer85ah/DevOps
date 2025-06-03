# 🛠️ What every DevOps Engineer needs.

Welcome to a DevOps repository, currently in **scaffolding and boilerplate phase** focusing in design patterns to build and clean, modular and flexible CI/CD pipeline orchestrator for all or most types of pipelines. The goal is to be a comprehensive, hands-on repository demonstrating how to build, test, and deploy a wide range of application types.

This repository highlights the most important responsibilities of a DevOps Engineer, ranked by impact. Whether you're just starting your DevOps journey or looking to deepen your expertise across environments and tech stacks, this repository aims to be your go-to resource for real-world pipeline implementations.

## 📌 Ranked Responsibilities

1. **Automate CI/CD Pipelines**  
   Automating build, test, and deployment processes is core to DevOps. It ensures fast, reliable, and repeatable software delivery.

2. **Manage Infrastructure as Code (IaC)**  
   Use tools like Terraform, CloudFormation, or Pulumi to provision and manage infrastructure efficiently, consistently, and scalably.

3. **Ensure System Reliability and Monitoring**  
   Set up logging, metrics, alerts, and incident response to maintain system uptime and performance.

4. **Implement and Enforce Security Best Practices**  
   Integrate secrets management, access controls, and secure configurations throughout the development lifecycle.

5. **Collaborate Across Teams**  
   Work closely with developers, QA, and IT to streamline workflows, troubleshoot issues, and support a culture of shared ownership.


## 🎯 Goal

To provide a curated collection of **modular**, **production-inspired**, and **environment-aware** CI/CD workflows that:
- Work across **frontend**, **backend**, **infrastructure**, **database**, and **machine learning** projects
- Use **GitHub Actions** to automate builds, testing, and deployment
- Support **multi-environment promotion** (dev → UAT → staging → prod)
- Demonstrate **best practices** in automation, security, testing, and rollback
- Guide aspiring and current DevOps engineers on key focus areas.
- Encourage collaboration and learning in the DevOps community.

## 🔧 What This Repo Contains

- Reusable Actions & Workflows: Common CI/CD steps are abstracted into reusable GitHub Actions and workflows.

- App Simulations: Each subdirectory in the apps/ folder simulates a standalone application (e.g., frontend, backend, ML, APIs).

- CI/CD Examples: End-to-end examples of testing, building, and deploying different app types.

- Documentation: Clear guides on structure, usage, best practices, and examples.

## 📁 Folder Overview

```text
devops/
├── .github/
│   ├── actions/            # Custom reusable actions
│   ├── workflows/          # Shared reusable workflows (CI, CD, etc.)
│   └── templates/          # Optional templates per app type
├── apps/                   # Example apps (simulated as separate repos)
├── docs/                   # Project documentation
└── README.md               # Project summary
```

## CI (Continuous Integration) Steps

**Focus:** Build, test, and prepare the application artifact.

- **Checkout Code**  
  Pull source code from the repository.

- **Install Dependencies**  
  Set up language/runtime dependencies.

- **Static Code Analysis / Linting**  
  Run linters and code quality checks.

- **Run Unit Tests**  
  Execute unit and integration tests.

- **Build Application**  
  Compile or build the app (e.g., Docker image, binary, JAR).

- **Package Artifact**  
  Package build output (Docker image, JAR, ZIP, etc.)

- **Publish Artifact**  
  Push artifact to a registry or artifact repository.

## CD (Continuous Deployment/Delivery) Steps

**Focus:** Deploy the artifact to environments.

- **Fetch Artifact**  
  Retrieve the build artifact from the registry/repository.

- **Deploy to Environment**  
  Deploy the artifact to dev, staging, production, etc.

- **Run Smoke Tests / Sanity Checks**  
  Verify deployment success with minimal tests.

- **Apply Deployment Strategy**  
  Use rolling update, blue/green, canary, etc.

- **Monitor Deployment**  
  Watch logs, metrics, alerts.

- **Notify Stakeholders**  
  Send notifications on deployment status.


### 🧠 Summary Table (CI/CD Step Importance)

| Step                   | Prototype | Dev | Staging | Prod |
|------------------------|:---------:|:---:|:-------:|:----:|
| Checkout               | ✅        | ✅  | ✅      | ✅   |
| Install                | ✅        | ✅  | ✅      | ✅   |
| Lint                   | 🔁        | ✅  | ✅      | ✅   |
| Unit Tests             | 🔁        | ✅  | ✅      | ✅   |
| Build                  | 🔁        | ✅  | ✅      | ✅   |
| Package                | ❌        | 🔁  | ✅      | ✅   |
| Publish Artifact       | ❌        | 🔁  | ✅      | ✅   |
| Fetch Artifact         | ❌        | 🔁  | ✅      | ✅   |
| Deploy                 | ❌        | ✅  | ✅      | ✅   |
| Smoke Tests            | ❌        | ❌  | ✅      | ✅   |
| Strategy (e.g., canary)| ❌        | ❌  | 🔁      | ✅   |
| Monitor                | ❌        | ❌  | 🔁      | ✅   |
| Notify                 | ❌        | ❌  | 🔁      | ✅   |

> ✅ = Always  🔁 = Recommended  ❌ = Optional/Skip

### 🔁 Summary of Recommendations

| Workflow | Trigger           | Branch(es)                  | Notes                                          |
|----------|-------------------|-----------------------------|------------------------------------------------|
| `ci.yml` | `push`, `pull_request` | `dev`, `feature/*`, `main`     | Run always. Fast feedback for all work.        |
| `cd.yml` | `push`            | `main → staging`            | Automated safe deploy after merge.             |
| `cd.yml` | `push`            | `release/*` or `tags → prod` | Production deploy from locked down branch.     |
| `cd.yml` | `workflow_dispatch` | Any                        | Use for manual deployments, hotfixes, or UAT.  |


## 🔧 What's Included

Reusable Workflows, To avoid duplication and enforce consistency, reusable workflows are stored under CI module.

App Type	      Pipeline Features
- Frontend	      Build, lint, test, deploy (e.g., React to Vercel/Netlify)
- Backend	      API test + deploy (Node, Python)
- Infra	          Terraform validate, plan, apply
- Databases	      Migration, backup, and rollout pipelines
- ML	          Model packaging and deploy (e.g., FastAPI + Docker)

## 🔁 Environments and Promotion

Pipelines are designed for multiple environments:

- development: fast feedback, automated
- uat: requires approval
- staging: mirrors production
- production: gated deployments with rollback support

## 🤝 Contributing

Contributions are welcome! If you have suggestions, new ideas, or improvements, please feel free to:
- Fork the repo
- Create a new branch
- Submit a pull request

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

👨‍💻 Author

Founded and maintained by Rainer Arencibia and the DevOps community contributions. 
This repo has been made with ❤️ by DevOps engineers for the DevOps community.
