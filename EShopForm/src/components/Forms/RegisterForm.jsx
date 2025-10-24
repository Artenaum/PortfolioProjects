import * as yup from "yup"
import { yupResolver } from "@hookform/resolvers/yup"
import { useForm } from "react-hook-form"
import InputField from "../InputField/InputField"

const schema = yup.object({
	firstName: yup.string().required("First name is required").min(2, "Miminum length is 2"),
	lastName: yup.string(),
	username: yup.string().required("Username is required").min(2, "Minimum length is 2"),
	email: yup.string().required("Email is required").email("Email not correct"),
	password: yup.string().required("Password is required").min(6, "Password not valid"),
	repeatPassword: yup.string().required("Repeat your password").oneOf([yup.ref("password"), null], "Passwords must match!"),
})

const RegisterForm = ({setCurrentFormState}) => {
	const {
		register,
		handleSubmit,
		formState: {
			errors,
		}
	} = useForm({
		mode: "all",
		resolver: yupResolver(schema),
	})

	const onSubmit = (data) => {
		fetch("https://jsonplaceholder.typicode.com/users", {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				id: Date.now(),
				name: data.lastName !== null ? 
					data.firstName + ' ' + data.lastName : data.firstName,
				username: data.username,
				email: data.email,
			}),
		})
		.then(response => {
			if (!response.ok) {
				throw new Error(`Error! Status: ${response.status}`);
			}
			return response.json();
		})
		.then(json => console.log(json))

		setCurrentFormState('login')
	}
		

	return (
		<div className="form-container">
			<h1>Create Account</h1>
			<form className="form" onSubmit={handleSubmit(onSubmit)}>
				<InputField
					labelValue="First Name:"
					inputType="text"
					register={register}
					value="firstName"
					placeholder="First Name"
					errorMessage={errors.firstName?.message}
				/>
				<InputField
					labelValue="Last Name:"
					inputType="text"
					register={register}
					value="lastName"
					placeholder="Last Name"
					errorMessage={errors.lastName?.message}
				/>
				<InputField
					labelValue="Username:"
					inputType="text"
					register={register}
					value="username"
					placeholder="Username"
					errorMessage={errors.username?.message}
				/>
				<InputField
					labelValue="Email:"
					inputType="text"
					register={register}
					value="email"
					placeholder="Email"
					errorMessage={errors.email?.message}
				/>
				<InputField
					labelValue="Password:"
					inputType="password"
					register={register}
					value="password"
					placeholder="Password"
					errorMessage={errors.password?.message}
				/>
				<InputField
					labelValue="Repeat Password:"
					inputType="password"
					register={register}
					value="repeatPassword"
					placeholder="Repeat Password"
					errorMessage={errors.repeatPassword?.message}
				/>
				<div className="form-register-link-and-button">
					<a className="form-link-3" onClick={() => setCurrentFormState('login')}>Sign In</a>
					<input type="submit" className="submit-button" id="register-button" value="Sign Up"/>
				</div>
			</form>
		</div>
	)
}

export default RegisterForm